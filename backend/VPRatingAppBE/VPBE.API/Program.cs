using AspNetCoreRateLimit;
using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using NLog;
using System.Reflection;
using System.Text;
using VPBE.Domain.Extensions;
using VPBE.Domain.Middlewares;
using VPBE.Infrastucture.Core;
using VPBE.Service.Implementations;
using VPBE.Domain.Interfaces;

namespace VPBE.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var logger = LogManager.GetCurrentClassLogger();
            try
            {
                var builder = WebApplication.CreateBuilder(args);

                builder.Configuration.AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")}.json", optional: true, reloadOnChange: true);
                var services = builder.Services;
                var host = builder.Host;

                host.AddLoggingConfiguration();
                services.AddControllersWithViews();
                services.AddHttpContextAccessor();
                services.AddCors();
                services.AddEndpointsApiExplorer();

                services.AddMemoryCache();
                services.Configure<IpRateLimitOptions>(builder.Configuration.GetSection("IpRateLimiting"));
                services.AddSingleton<IIpPolicyStore, MemoryCacheIpPolicyStore>();
                services.AddSingleton<IRateLimitCounterStore, MemoryCacheRateLimitCounterStore>();
                services.AddSingleton<IRateLimitConfiguration, RateLimitConfiguration>();
                services.AddSingleton<IProcessingStrategy, AsyncKeyLockProcessingStrategy>();

                services.AddSwaggerGen(c =>
                {
                    c.SwaggerDoc("v1", new OpenApiInfo { Title = "VP API", Version = "v1" });

                    c.AddSecurityDefinition(JwtBearerDefaults.AuthenticationScheme, new OpenApiSecurityScheme
                    {
                        Name = "Authorization",
                        In = ParameterLocation.Header,
                        Type = SecuritySchemeType.ApiKey,
                        Scheme = JwtBearerDefaults.AuthenticationScheme,
                        BearerFormat = "JWT"
                    });

                    c.AddSecurityRequirement(new OpenApiSecurityRequirement
                    {
                        {
                            new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = JwtBearerDefaults.AuthenticationScheme
                                },
                                Scheme = "Oauth2",
                                Name = JwtBearerDefaults.AuthenticationScheme,
                                In = ParameterLocation.Header
                            },
                            new List<string>()
                        }
                    });
                });

                services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                }).AddJwtBearer(options =>
                {
                    options.SaveToken = true;
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = builder.Configuration["JwtAuthentication:ValidIssuer"],
                        ValidAudience = builder.Configuration["JwtAuthentication:ValidAudience"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JwtAuthentication:SecretKey"])),
                        ClockSkew = TimeSpan.FromSeconds(10)
                    };
                    options.Events = new JwtBearerEvents
                    {
                        OnChallenge = context =>
                        {
                            return Task.CompletedTask;
                        },
                        OnTokenValidated = context =>
                        {
                            return Task.CompletedTask;
                        },
                        OnForbidden = context =>
                        {
                            return Task.CompletedTask;
                        },
                        OnMessageReceived = context =>
                        {
                            return Task.CompletedTask;
                        },
                        OnAuthenticationFailed = context =>
                        {
                            if (context.Exception.GetType() == typeof(SecurityTokenExpiredException))
                            {
                                context.Response.Headers.Add("IS-TOKEN-EXPIRED", "true");
                            }
                            return Task.CompletedTask;
                        }
                    };
                });
                services.AddDbContext<VPDbContext>(options =>
                {
                    options.UseSqlServer(builder.Configuration["ConnectionStrings:DBConnections"]);
                });
                services.AddScoped<DbContext, VPDbContext>();
                services.AddScoped<IDBRepository, DBRepository>();
                services.AddScoped<ITokenService, TokenService>();

                var app = builder.Build();

                // Configure the HTTP request pipeline.
                app.UseHttpsRedirection();
                app.UseStaticFiles();
                app.UseMiddleware<RequestTimingMiddleware>();
                app.UseRouting();

                app.UseIpRateLimiting();
                if (app.Environment.IsDevelopment())
                {
                    app.UseCors();
                    app.UseSwagger();
                    app.UseSwaggerUI(c =>
                    {
                        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Portal API V1");
                    });
                }
                app.UseAuthentication();
                app.UseAuthorization();

                app.MapControllers();
                app.UseEndpoints(endpoints =>
                {
                    endpoints.MapControllerRoute(
                        name: "default",
                        pattern: "{controller=Home}/{action=Index}");
                });
                app.Run();
            }
            catch (Exception ex)
            {
                logger.Error("Stop program because of exception", ex);
                throw;
            }
            finally
            {
                LogManager.Shutdown();
            }

        }
    }
}

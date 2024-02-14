using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog;
using NLog.Config;
using NLog.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Extensions
{
    public static class HostBuilderExtension
    {
        public static ConfigureHostBuilder AddLoggingConfiguration(this ConfigureHostBuilder builder)
        {
            builder.ConfigureLogging((context, logging) =>
            {
                logging.ClearProviders();
                LogManager.Configuration = new XmlLoggingConfiguration("nlog.config");
                string directory = AppDomain.CurrentDomain.BaseDirectory;

                var isDevelopment = string.Equals(context.HostingEnvironment.EnvironmentName, Constants.DevEnv, StringComparison.OrdinalIgnoreCase);
                if (isDevelopment)
                {
                    logging.AddConsole();
                }
                var loggingDirectory = context.Configuration["LoggingDirectory"];

                if (!string.IsNullOrEmpty(loggingDirectory))
                {
                    loggingDirectory = loggingDirectory.TrimStart('~', '\\', '/');
                    if (Directory.Exists(loggingDirectory))
                    {
                        directory = loggingDirectory;
                    }
                    else if (directory.IndexOf(loggingDirectory, StringComparison.OrdinalIgnoreCase) > -1)
                    {
                        var tempDirectory = Path.Combine(directory.Substring(0, directory.LastIndexOf(loggingDirectory, StringComparison.OrdinalIgnoreCase)), loggingDirectory);
                        if (Directory.Exists(tempDirectory))
                        {
                            directory = tempDirectory;
                        }
                    }
                }

                if (LogManager.Configuration != null)
                {
                    var appVersion = Environment.GetEnvironmentVariable("AppVersion");
                    if (string.IsNullOrEmpty(appVersion))
                    {
                        appVersion = Assembly.GetExecutingAssembly().GetName().Version.ToString();
                    }
                    LogManager.Configuration.Variables["appVersion"] = appVersion;
                    LogManager.Configuration.Variables["baseDir"] = directory;
                }
            });

            builder.UseNLog();
            return builder;
        }
    }
}

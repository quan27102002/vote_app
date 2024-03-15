using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Extensions
{
    public static class EnumExtensions
    {
        public static string ToDescription<TEnum>(this TEnum EnumValue) where TEnum : struct
        {
            Type type = typeof(TEnum);

            MemberInfo[] memInfo = type.GetMember(EnumValue.ToString());

            if (memInfo != null && memInfo.Length > 0)
            {
                object[] attrs = memInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);

                if (attrs != null && attrs.Length > 0)
                {
                    return ((DescriptionAttribute)attrs[0]).Description;
                }
            }

            return EnumValue.ToString();
        }
    }
}

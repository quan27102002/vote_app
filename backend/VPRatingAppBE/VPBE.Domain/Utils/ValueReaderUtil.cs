using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Utils
{
    public class ValueReaderUtil
    {
        /// <summary>
        /// example path: a.b.c means read value of obj.a.b.c
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static object ReadValue(object obj, string path)
        {
            //split path
            var paths = path.Split('.');

            object nextobj = obj;
            foreach (var p in paths)
            {
                nextobj = ReadOneValue(nextobj, p);
            }

            return nextobj;
        }

        private static object ReadOneValue(object obj, string path)
        {
            if (obj == null)
            {
                return null;
            }

            Type t = obj.GetType();
            //var allmember = t.GetMembers();
            var members = t.GetMember(path, BindingFlags.Instance | BindingFlags.Public);
            if (members == null || members.Length == 0)
            {
                return null;
            }

            //unique
            var field = members[0] as FieldInfo;
            if (field != null)
            {
                return field.GetValue(obj);
            }

            var property = members[0] as PropertyInfo;
            if (property != null)
            {
                return property.GetValue(obj);
            }

            return null;
        }
    }
}

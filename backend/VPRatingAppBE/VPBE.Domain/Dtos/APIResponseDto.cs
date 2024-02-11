using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Dtos
{
    public class APIResponseDto
    {
        public int Code { get; set; }
        public string Message { get; set; } = string.Empty;
        public int Status { get; set; }
    }

    public class APIResponseDto<T> : APIResponseDto
    {
        public T Data { get; set; }
    }
}

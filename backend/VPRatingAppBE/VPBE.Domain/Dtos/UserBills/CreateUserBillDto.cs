﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.UserBills
{
    public class CreateUserBillDto
    {
        public Guid Id { get; set; }
        public string BillCode { get; set; }
        public List<BranchService> Service { get; set; }
    }
}

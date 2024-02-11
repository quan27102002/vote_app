using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Models.Comments;

namespace VPBE.Domain.Validators.Comments
{
    public class SubmitCommentRequestValidators : AbstractValidator<SubmitCommentRequest>
    {
        public SubmitCommentRequestValidators()
        {
            RuleFor(request => request).Must(a =>
            {
                if (a == null) return false;
                return true;
            });
        }
    }
}

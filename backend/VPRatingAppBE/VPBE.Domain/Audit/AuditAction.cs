using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Audit
{
    public enum AuditAction
    {
        [Description("")]
        None = 0,
        //User
        [Description("Đăng nhập")]
        SignIn = 1,
        [Description("Đăng xuất")]
        SignOut,
        [Description("Đăng kí tài khoản")]
        RegisterUser,
        [Description("Xem thông tin người dùng trong hệ thống")]
        ViewAllUsers,
        [Description("Refresh token")]
        RefreshToken,
        [Description("Xem thông tin token bị vô hiệu hóa")]
        ViewInvalidateToken,
        [Description("Kích hoạt tài khoản")]
        ActivateAccount,
        [Description("Vô hiệu hóa tài khoản")]
        DeactivateAccount,

        //Report
        [Description("Thống kê toàn bộ")]
        Filter = 100,
        [Description("Thống kê theo mức độ đánh giá")]
        FilterByLevel,
        [Description("Xuất báo cáo")]
        Export,

        //Image
        [Description("Upload ảnh")]
        BulkUpload = 200,
        [Description("Xem ảnh")]
        ViewImages,

        // User bill
        [Description("Lưu hóa đơn")]
        CreateUserBill = 300,

        // Comment
        [Description("Xem thông tin các bình luận")]
        ViewAllComments = 400,
        [Description("Cập nhật bình luận")]
        EditComment,
        [Description("Hoàn tất đánh giá")]
        SubmitComment,
        [Description("Lọc bình luận theo thể loại")]
        ViewCommentsByType,
        [Description("Lọc bình luận theo mức độ")]
        ViewCommentByLevel,
    }
}

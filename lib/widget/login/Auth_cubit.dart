// import 'package:bloc/bloc.dart';
// import 'package:vote_app/widget/login/Auth_error.dart';
// import 'package:vote_app/widget/login/Auth_state.dart';
// import 'package:http/http.dart' as http;
// import 'package:vote_app/widget/login/Auth_state.dart';

// import 'Model_user.dart';
// class AuthCubit extends Cubit<AuthLogin>{
//   final String baseUrl;
//   AuthCubit( this.baseUrl):super(AuthLogin.initial());
// Future<Map<String, Object>> login(String username,String password) async {
//   emit(AuthLogin.initial());
//   final response = await http.post(
//       Uri.parse(''),
//       body: {'username': username, 'password': password},
//     );
// emit(LogInProgress());
//     if (response.statusCode == 200) { 
//       User use=new User(email: ,)
//       emit(LogInSucess( user:User));
//       return {'success': true, 'data': response.body};
    
//     } else {
//       emit(LogInFailre( authError: authError));
//       return {'success': false, 'error': response.body};
//     }
// }
// }
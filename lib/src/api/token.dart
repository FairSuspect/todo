import 'package:todo/src/misc/dotenv.dart';

class TokenRepository {
  static final _tokenRepository = TokenRepository._();
  TokenRepository._();
  factory TokenRepository() => _tokenRepository;

  String getAccessToken() => Dotenv().getValue('TOKEN');
}

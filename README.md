
# Integração do Tuya SDK com o Flutter

>[!IMPORTANT]
> Toda a documentação do Tuya SDK como configuração do projeto está nos links abaixo.

<a href="#links">Links &#128279;</a><br/>
<a href="#integration">Integração &#128279;</a><br/>
<a href="#user_register">Registro de usuário &#128279;</a><br/>

<h2 id="links">Links</h2>
### Tuya Doc

<a href="https://developer.tuya.com/">Developer Tuya</a>
<a href="https://developer.tuya.com/en/docs/app-development/featureoverview?id=Ka69nt97vtsfu">Guia de desenvolvimento para Android-IoT App SDK-Tuya</a>

### Flutter

<a href="https://docs.flutter.dev/platform-integration/platform-channels">Platform Channels</a>
<a href="https://api.flutter.dev/flutter/services/MethodChannel-class.html">MethodChannel Class</a>
<a href="https://medium.com/cashify-engineering/event-channel-to-listen-to-broadcast-events-from-android-43a813672896#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImEwNmFmMGI2OGEyMTE5ZDY5MmNhYzRhYmY0MTVmZjM3ODgxMzZmNjUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDg4MTU4NDAzNjg5NzAwOTEzODIiLCJlbWFpbCI6ImdhYnJpZWxjYXN0cm9tYWlsQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYmYiOjE2OTg0MTc1NDUsIm5hbWUiOiJHYWJyaWVsIFNvdXphIENhc3RybyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NJUTlZbHJHRlk2NUhCOHFGYnhZYXBYdkVkNEFhY3I0aGdaRzNRd1Zka0NQRmM9czk2LWMiLCJnaXZlbl9uYW1lIjoiR2FicmllbCIsImZhbWlseV9uYW1lIjoiU291emEgQ2FzdHJvIiwibG9jYWxlIjoicHQtQlIiLCJpYXQiOjE2OTg0MTc4NDUsImV4cCI6MTY5ODQyMTQ0NSwianRpIjoiNWFmOTExNDMyZTQ3NGJlYmZiYjg3MDVmYTUyZjcxYTE0ZTdjMjU0OCJ9.GicWaeYsNVhPEnubR2xYIKC_RuKXYSBgNx5ThHttNCDBnPoeCKfxegbqZzWBwuKfO9MA7hY33_cHnyYYszB_hoyMO0d9OpH5HE-ffW3t3jdjuH3vh4Cp6MchOCN9mjaWdxNZc4yBakcbd2ICTbaZOCDkibDPi4pNqlZRA7FCbitnpJXOoV-O9r62vdbuGNvi34RMpqSugakeciSjt0K0j8qTr7Q61SienJf4ynCQgWNhnAM1Cf9JwSZRBxuDmc3EpuC8Y7BOV1yl0EBYSWxn2ijBX-19UvkcZ6Q_HtkpgD9dhQF1oIVN3IY9a439FgitE7hK_yigg59YqxATVFfJzw">Event channel to listen Broadcast receiver’s event</a>

<br><br>

<h2 id="integration">Integração</h2>

>[!IMPORTANT]
> **Lembre da Configuração do TuyaSDK**
>
> Lembre-se de configurar corretamente o SDK no app, de acordo com a documentação oficial.
> Caso não configure corretamente a AppKey, AppSecret e os demais, não conseguirá prosseguir.


Para integrar o código Kotlin com o Flutter será necessário utilizar o Method Channel no Flutter, dessa forma você cria um *CHANNEL* onde o valor será o mesmo tanto no Flutter quanto no Nativo, e por meio desse *CHANNEL* eles vão se conversar.

Por exemplo:

No Nativo foi criado um *companion object* com o *CHANNEL* e seu valor *tuya_integration*. Pode ser outro valor.


``` Kotlin
companion object {  
    const val CHANNEL = "tuya_integration"
}
```

Agora no flutter, eu também criei uma constante com o mesmo valor

``` Kotlin
class Constants {  
  static const CHANNEL = "tuya_integration";
}
```

Agora, ainda no Flutter, em alguma classe, ou na classe que irá utilizar, será necessário criar o MethodChannel com o valor para o *CHANNEL*

``` Kotlin
	static const channel = MethodChannel(Constants.CHANNEL);
```

Dessa forma consigo utilizar o channel e chamar alguma funcao que está no nativo, como por exemplo:

Utilizando o *invokeMethod* do *channel* consigo dizer qual a funcao do nativo que desejo chamar. Neste caso foi a função de nome **auth** e passo um objeto de chave-valor que a função solicita. Como é um login, preciso passar as informações de email, password e código do país.

``` Kotlin
    _loginTuya() async {  
      await channel.invokeMethod("auth", <String, String>{  
        "country_code": "55",  
        "email": _emailController.text,  
        "password": _passwController.text  
      }); 
    }
```

Lá no código nativo, vamos precisar criar uma função que será chamada quando o channel invocar o método **auth**.

No Nativo, nossa *MainActivity* vai herdar da FlutterActivity() que vai nos fornecer um método para configurar a Engine do Flutter, que é o

``` Kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {  
    super.configureFlutterEngine(flutterEngine)
}
```

Vamos criar uma variavel do tipo MethodChannel e inicializar ela dentro da função *configureFlutterEngine* lembrando que o *CHANNEL passado dentro do MethodChannel* é a constante criada no companion object.

``` Kotlin
private lateinit var channel: MethodChannel

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {  
    super.configureFlutterEngine(flutterEngine)  
  
    channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
}
```

Dessa forma, podemos utilizando o channel, chamar a função setMethodCallHandler() que vai nos fornecer um *call* e um *result*.

- CALL ->  dentro do call temos o *method* que será o método chamado pelo Flutter, por exemplo: Foi chamado a função auth, então o call será *auth*.
- RESULT -> é a forma de retornarmos algo para o Flutter, como o retorno de uma função.

No caso da função de autenticação, dentro do setMethodCallHandler fica algo assim:

``` Kotlin
if (call.method == "auth") {    
    ThingHomeSdk.getUserInstance().loginWithEmail(  
        countryCode.toString(),  
        email.toString(),  
        password.toString(),  
        object : ILoginCallback {  
            override fun onSuccess(user: User?) {  
                user?.let {  
                    result.success(it.uid)  
                }  
            }  
  
            override fun onError(code: String?, error: String?) {  
                if (code != null && error != null) {  
                    result.error(code, error, null)  
                };  
            }  
        }  
    )  
}
```

Isso quer dizer que se o method chamado fo *auth* ele vai chamar essa função que está dentro. E observe que dentro do callback temos o result, onde da um result.success que retorna o UID do usuário e outro que retorna o código e erro, caso tenha erros.

Isso será feito o tempo inteiro, para cada função chamada.

### Argumentos

Outro fator importante para a integração são os argumentos passados quando chamamos a função.

Se observou bem, quando chamamos a função no Flutter passamos alguns argumentos como email, senha, etc.

Para que no Kotlin consigamos pegar esses dados, vamos precisar utilizar o *ARGUMENTS* que fica dentro do *CALL*
*ARGUMENTS* será um Map de <String, String> ou <*, *>. Neste caso estamos utilizando apenas como String.
E dentro desse Map teremos como pegar cada um dos parametros informados.

``` Kotlin 
val argument = call.arguments as Map<String, String>
val countryCode = argument["country_code"]
val email = argument["email"]
val password = argument["password"]
val code = argument["code"]
```

Dessa forma, agora consigo pegar o valor passado na função Flutter e passar ele dentro de alguma função no Kotlin.

<br><br>

<h2 id="user_register">Registro de usuário</h2>

Para realizar o registro de um usuário, é importante seguir alguns passos.

1. Enviar código de registro para email do usuário
2. Registrar email e senha do usuário juntamente com o código recebido no email

Outo ponto importante são as informações solicitadas para registro de usuários

 - Código do país
 - E-mail
 - Senha
 - Código enviado por email

### Enviar código de registro

Então para que o registro aconteça, primeiramente chamamos via o *MethodChannel* o método para receber o código 
de registro. Lembrando que deve ser passado juntamente o email e código do país.

Vamos adicionar uma constante chamada SEND_CODE tanto no Nativo quanto no Flutter, para chamarmos por constante, 
fica mais organizado.

<code-block lang="kotlin">
    // Kotlin
    companion object {
        const val SEND_CODE = "send_code"
        const val REGISTER = "register"
    }
</code-block>
<code-block lang="kotlin">
    // Dart
    class Method {
        static const SEND_CODE = "send_code";
        static const REGISTER = "register";
    }
</code-block>

No Flutter, vamos chamar a função e passar os parametros necessários 
 
``` Kotlin
    Future<void> _validateTuya() async {
        await channel.invokeMethod(
          Methods.SEND_CODE, <String, String>{
          "country_code": countryCodeController,
          "email": emailController
        });
    }
```

E no Kotlin, vamos ter a função que será executada quando o method SEND_CODE for chamado.

>[!IMPORTANT]
> Observe que chamamos de dentro do *getUserInstance()* a função *sendVerifyCodeWithUserName()* e ela solicita alguns parametros.
> Caso tenha dúvidas sobre cada um, basta olhar na própria documentação
> [User Doc](https://developer.tuya.com/en/docs/app-development/useremail?id=Ka6a99luv3tr1)
> 


``` Kotlin
   if (call.method == SEND_CODE) {
        ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
            email.toString(),
            "",
            countryCode.toString(),
            1,
            object : IResultCallback {
                override fun onError(code: String?, error: String?) {
                    Toast.makeText(context, "Erro: $code - $error", Toast.LENGTH_LONG)
                        .show()
                }

                override fun onSuccess() {
                    Toast.makeText(context, "Codigo enviado", Toast.LENGTH_LONG)
                        .show()
                }
            }
        )
    }
```

O que essa função vai fazer é, basicamente, enviar um código de registro para o e-mail informado.
Você pode tratar o erro e sucesso como preferir.

Após receber o código de registro, será necessário chamar outra função, que é a de registrar o usuário no app.

### Registrar usuário

Criamos a função no nativo

``` Kotlin 
if (call.method == REGISTER) {
        ThingHomeSdk.getUserInstance().registerAccountWithEmail(
            countryCode.toString(),
            email.toString(),
            password.toString(),
            code.toString(),
            object : IRegisterCallback {
                override fun onSuccess(user: User?) {
                    Toast.makeText(context, "User: $user", Toast.LENGTH_LONG)
                        .show()
                }

                override fun onError(code: String?, error: String?) {
                    Toast.makeText(context, "Erro: $code - $error", Toast.LENGTH_LONG)
                        .show()
                }
            }
        )
    }
```

Dessa vez utilizamos os argumentos solicitados juntamente cmo o codigo de registro.
Novamente, você escolhe como tratar o erro e sucesso, mas recomendo caso tenha sucesso utilizar o 
*RESULT* para retornar algo para o Flutter e assim poder exibir um feedback para o usuário, ou navegar para a tela 
de login após registro.


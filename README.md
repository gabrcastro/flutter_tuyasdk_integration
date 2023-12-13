
# Integração do Tuya SDK com o Flutter

>[!IMPORTANT]
> Toda a documentação do Tuya SDK como configuração do projeto está nos links abaixo.

<br><br>
- <a href="#links">Links</a> <br/>

- <a href="#integration">Integração</a> <br/>
 
- <a href="#user_register">Registro de usuário</a> <br/>

- <a href="#user_auth">Autenticação de usuário</a> <br/>
	- <a href="#login">Login</a><br>
	- <a href="#logged">Manter conectado</a><br>
	- <a href="#logout">Logout</a><br>
 
 
- <a href="#search_blue_devices">Buscar dispositivos por bluetooth<a> <br />
<br><br>

<details open><summary><h2 id="links">Links</h2></summary>

<a href="https://www.figma.com/file/3WIEOZpezC2qoLUbU4rBBs/Fluxo---Integracao-com-Tuya?type=whiteboard&node-id=0%3A1&t=uvwXLJttxV2DsWq8-1" target="_blank">Fluxograma - Figma</a>

<a href="https://developer.tuya.com/" target="_blank">Developer Tuya</a> <br>
<a href="https://developer.tuya.com/en/docs/app-development/featureoverview?id=Ka69nt97vtsfu" target="_blank">Guia de desenvolvimento para Android-IoT App SDK-Tuya</a> <br>

<a href="https://docs.flutter.dev/platform-integration/platform-channels" target="_blank">Platform Channels</a> <br>
<a href="https://api.flutter.dev/flutter/services/MethodChannel-class.html" target="_blank">MethodChannel Class</a> <br>
<a href="https://medium.com/cashify-engineering/event-channel-to-listen-to-broadcast-events-from-android-43a813672896#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImEwNmFmMGI2OGEyMTE5ZDY5MmNhYzRhYmY0MTVmZjM3ODgxMzZmNjUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDg4MTU4NDAzNjg5NzAwOTEzODIiLCJlbWFpbCI6ImdhYnJpZWxjYXN0cm9tYWlsQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYmYiOjE2OTg0MTc1NDUsIm5hbWUiOiJHYWJyaWVsIFNvdXphIENhc3RybyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NJUTlZbHJHRlk2NUhCOHFGYnhZYXBYdkVkNEFhY3I0aGdaRzNRd1Zka0NQRmM9czk2LWMiLCJnaXZlbl9uYW1lIjoiR2FicmllbCIsImZhbWlseV9uYW1lIjoiU291emEgQ2FzdHJvIiwibG9jYWxlIjoicHQtQlIiLCJpYXQiOjE2OTg0MTc4NDUsImV4cCI6MTY5ODQyMTQ0NSwianRpIjoiNWFmOTExNDMyZTQ3NGJlYmZiYjg3MDVmYTUyZjcxYTE0ZTdjMjU0OCJ9.GicWaeYsNVhPEnubR2xYIKC_RuKXYSBgNx5ThHttNCDBnPoeCKfxegbqZzWBwuKfO9MA7hY33_cHnyYYszB_hoyMO0d9OpH5HE-ffW3t3jdjuH3vh4Cp6MchOCN9mjaWdxNZc4yBakcbd2ICTbaZOCDkibDPi4pNqlZRA7FCbitnpJXOoV-O9r62vdbuGNvi34RMpqSugakeciSjt0K0j8qTr7Q61SienJf4ynCQgWNhnAM1Cf9JwSZRBxuDmc3EpuC8Y7BOV1yl0EBYSWxn2ijBX-19UvkcZ6Q_HtkpgD9dhQF1oIVN3IY9a439FgitE7hK_yigg59YqxATVFfJzw" target="_blank">Event channel to listen Broadcast receiver’s event</a> <br>

<a href="https://pub.dev/packages/flutter_colorpicker">Flutter ColorPicker</a><br />
</details>

<details open><summary><h2 id="integration">Integração</h2></summary>

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
</details>

<details open><summary><h2 id="user_register">Registro de usuário</h2></summary>

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
</details>

<details open><summary><h2 id="user_auth">Autenticação de usuário</h2></summary>

>[!Important]
> As constantes apresentadas você pode cria-las no seu código. Como já foi apresentado, não vou criá-las novamente.

<h3 id="login">Login</h3>

Para realizar o login, os argumentos passados são:

 - E-mail
 - Senha
 - Código do país

Assim como nos demais, deve-se criar as constantes no Flutter e Kotlin.
Não vou ficar recriando o código no Flutter, pois segue o mesmo padrão.

A função no Kotlin será algo assim:

``` Kotlin 
if (call.method == AUTHENTICATE) {
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

Neste caso, caso tenha sucesso estou retornando o UID, que é o ID do usuário autenticado.
E ai é interessante armazenar esse UID no Flutter, talvez cm o SharedPreferences, para mantê-lo logado futuramente.

No Flutter, após receber o UID, poderá navegar para a HOME do app.
Caso tenha um erro, deve tratá-lo como for melhor.

<h3 id="logged">Manter conectado</h3>

Sempre que abrir o app, será necessário verificar se o usuário já está logado ou não.
Para isso, podemos chamar a função

``` Kotlin 
if (call.method == ALREADY_LOGGED) {
    val isLogged = ThingHomeSdk.getUserInstance().isLogin
    result.success(isLogged)
}
```

Ela vai verificar e retornar um Booleano. No Flutter podemos tratar isso e caso esteja, navegar para dentro do app.

<h3 id="logout">Logout</h3>

A função para realizar logout do usuário é simples, pois o próprio SDK do tuya já nos fornece tudo.

``` Kotlin 
if (call.method == LOGOUT) {
    ThingHomeSdk.getUserInstance().logout(object : ILogoutCallback {
        override fun onSuccess() {
            Toast.makeText(context, "Logout success", Toast.LENGTH_SHORT).show()
            result.success(true)
        }

        override fun onError(p0: String?, p1: String?) {
            Toast.makeText(context, p1.toString(), Toast.LENGTH_SHORT).show()
            result.error(p0.toString(), p1.toString(), null)
        }
    })
}
```

Caso tenha sucesso ou erro, novamente, trate no flutter como necessário.

Lembrando sempre de utilizar o *result.success()* com algum valor importante para ter um retorno sobre a função.
</details>

<details open><summary><h2 id="search_blue_devices">Buscar dispositivos por bluetooth</h2></summary>

### Realizar a varredura

Atualmente estamos buscando os dispositivos para realizar pareamento via bluetooth.
Para isso, é necessário solicitarmos a permissão do uso de bluetooth no app.

Dentro do *AndroidManifest.xml* adicione as permissões

``` Kotlin
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
```

>[!IMPORTANT]
> Depois será necessário solicitar essas permissões para o usuário.
> Para fazer isso pode acessar a sessão de **Solicitar permissões ao usuário**.

Após termos adicionado as permissões no manifest, vamos ao código.

Seguindo o mesmo padrão, espero que já tenha criado as constantes necessárias, caso esteja fazendo dessa forma.
O Código aqui já apresenta essas constantes, então não mostrarei o processo de criação novamente.

Temos então a função que faz a busca por dispositivos



```Kotlin 
fun bluetoothScan(callback: (ScanDeviceBean?) -> Unit) {
    var deviceBean: ScanDeviceBean? = null

    Toast.makeText(context, "Blueetooth Scan", Toast.LENGTH_SHORT).show()

    val scanSetting = LeScanSetting.Builder()
        .setTimeout(60000)
        .addScanType(ScanType.SINGLE)
        .build()

    ThingHomeSdk.getBleOperator().startLeScan(
        scanSetting
    ) { bean ->
        callback(bean)
    }
}

if (call.method == SEARCH_DEVICES) {
    bluetoothScan { deviceBean ->
        Log.i("scan", "bluetoothScan: ${deviceBean?.name.toString()}")
        Toast.makeText(context, deviceBean?.data.toString(), Toast.LENGTH_SHORT).show()

        ThingHomeSdk.getActivatorInstance().getActivatorDeviceInfo(
            deviceBean?.productId,
            deviceBean?.uuid,
            deviceBean?.mac,
            object: IThingDataCallback<ConfigProductInfoBean> {
                override fun onSuccess(resConfigProductInfoBean: ConfigProductInfoBean?) {
                    Log.i("scan", "getDeviceInfo: ${resConfigProductInfoBean?.name.toString()}")
                    Toast.makeText(context, deviceBean?.data.toString(), Toast.LENGTH_SHORT).show()

                    if (resConfigProductInfoBean?.name != null) {
                        var deviceFound = arrayListOf(
                            resConfigProductInfoBean.name.toString(),
                            resConfigProductInfoBean.icon.toString()
                        )
                        result.success(deviceFound)
                    }
                }

                override fun onError(errorCode: String?, errorMessage: String?) {
                    Log.i("scan", "error getDeviceInfo: ${errorCode.toString()}")
                    Toast.makeText(context, errorMessage.toString(), Toast.LENGTH_SHORT).show()
                }
            })
    }

}
```

1. Observe que foi criado uma função fora do escopo ai da execução.
Essa função é responsável por configurar o necessário para quando formos fazer a varredura de novos dispositivos.
Ainda dentro dela, chamamos o startLeScan, passando as configurações necessárias.
E passamos uma função callback que será executada quando iniciar a varredura.
2. Essa função de callback é a função passada lá dentro do if abaixo.
3. Chamamos a função criada que solicita um callback, o nosso callback será executado
retornando algumas informações caso tenha sucesso ou erro.
4. É no retorno de sucesso que vamos pegar as informações do dispositivo encontrado e retornar para o Flutter. 
5. Este *Log.i...* que tem no código é apenas uma forma útil de capturar algumas informações durante a execução.
Neste caso, foi adicionado para no *LOG* enquanto o app é executado, eu consiga ter um retorno do nome do dispositivo.

Aqui é importante destacar os retornos. De acordo com a documentação do tuya, quando encontra o dispositivo
será retornado várias informações e uma delas é o *deviceType* que vai nos trazer o tipo do dispositivo encontrado.
É com esse tipo que vamos chamar a função correta para pareamento.

Temos os seguintes tipos

| 200	| config_type_single	     | Dispositivo Bluetooth                                                                                                       |
|-------|----------------------------|
| 300	| config_type_single	     | Dispositivo Bluetooth                                                                                                       |
| 301	| config_type_wifi	       | Dispositivo combinado Wi-Fi e Bluetooth                                                                                       |                                                                 
| 304	| config_type_wifi	       | Dispositivo combinado Wi-Fi e Bluetooth que suporta emparelhamento por Bluetooth se uma conexão Wi-Fi não estiver disponível  |
| 400	| config_type_single	     | Dispositivo Bluetooth                                                                                                       |                                                                                  
| 401	| config_type_wifi	       | Dispositivo combinado Wi-Fi e Bluetooth                                                                                       |                                                                   
| 404	| config_type_wifi        | Dispositivo combinado Wi-Fi e Bluetooth que suporta emparelhamento por Bluetooth se uma conexão Wi-Fi não estiver disponível   |

Caso queira encontrar, eis aqui o link: [Varredura de dispositivos](https://developer.tuya.com/en/docs/app-development/android-bluetooth-ble?id=Karv7r2ju4c21#title-1-Device%20scanning)

### Parar busca

Para para a busca por dispositivos, será necessário chamar uma outra função

``` kotlin
if (call.method == STOP_SEARCH_DEVICES) {
    ThingHomeSdk.getBleOperator().stopLeScan();
    result.success(true)
}
```

A função vai parar a varredura e retornar um *true* para o Flutter, para que assim seja possível retornar algum feedback para o usuário.

Dessa vez utilizamos os argumentos solicitados juntamente cmo o codigo de registro.
Novamente, você escolhe como tratar o erro e sucesso, mas recomendo caso tenha sucesso utilizar o 
*RESULT* para retornar algo para o Flutter e assim poder exibir um feedback para o usuário, ou navegar para a tela 
de login após registro.
</details>

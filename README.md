# university_loader

Projeto feito para estudar programação asyncrona com Isolates/Futures no fluter, para estudar também modularização no flutter para externar módulos/pacotes

# Arquitetura
  ## Commons:
  Módulo com classes comuns e necessárias para a amaior parte do projeto, como models e widgets padrão
  
  ## Core:
  Módulo com a camada de dados do projeto, classe com offline first (data_bound_resources.kt), services e dao. Módulo feito com a menor quantidade de bibliotecas terceiras possível, para evitar problemas de compatibilidade e compatibilidade de versões, assim aumentando o escalonamento do projeto.

  #### dependencias:
    commons:
      path: ../commons -> módulo com as models necessárias para o gerenciamento de dados
    sqflite: ^2.0.2+1 -> Persistência de dados
    http_interceptor: ^1.0.2 -> Log de requisições para API rest
    path: ^1.8.0 -> Caminhos de arquivos externos (criar e consumir)
    
  ### Construção do offline first:
  
  Offline first feito com Isolates fornecidos pelo dart:async, usados para ouvir quando há alteações no SendPort, ao terminar uma busca no banco ou uma requisição na api.
  A classe DataBoundResource contem callbacks em forma de variáveis que podem ser chamados para realizar a consulta no banco, realizar a requisição da api e salvar o resultado da requisição no banco sem que ocorra travamento na UI ou qualquer tipo de memory leak.
  Como exemplo, o build da classe que ordena as chamadas e retorna o ReceivePort (Isolate) usado que é usado como listener.
  O __sendPort__ fornecido pelo ReceivePort é responsável por notificar o ReceivePort com o objeto em questão.
  
  ```
  ReceivePort build() {
    var receivePort = ReceivePort();
    var sendPort = receivePort.sendPort;

    sendPort.send(Resource.loading());

    _fetchFromDatabase(sendPort);
    _crateCall(sendPort);

    return receivePort;
  }
  ```
  
  Neste caso especifico foi criado uma especie de wraper para os retornos da API e do banco, sendo ele o Resource. Este wraper é responsável apenas por manter o estado das requisições, o dado e se necessário a mensagem das mesmas.
  
  ```
  class Resource<T> {
  String? message;
  Status status;
  T? data;

    Resource({this.message, required this.status, this.data});

    static Resource success<T>(dynamic data) {
      return Resource(status: Status.success, data: data);
    }

    static Resource error<T>(String message) {
      return Resource(message: message, status: Status.error);
    }

    static Resource loading<T>({String? message}) {
      return Resource(message: message, status: Status.loading);
    }
  }
  ```
  
  Este método do DataBoundResource.dart é responsável notificar o callback e esperar até que ele termine a sua requisição e notifique o __sendPort__ que está sendo ouvido pelo método build da classe.
  ```
  void _crateCall(SendPort sendPort) async {
      Resource result = await createCall();
      if (result.status == Status.success) {
        sendPort.send(Resource.success(result.data));
        saveCallResult(result.data);
      }
      if (result.status == Status.error) {
        sendPort.send(Resource.error(result.message ?? ""));
      }
    }
  ```

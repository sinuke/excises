unit Data.Consts;

interface

const
  ANIMATION_DIRATION = 180;

  URL: string = 'http://ws.blank.bisc.by/FindBlankWSSoap.svc/';
  REQUEST_DATA: string = '<v:Envelope xmlns:i="http://www.w3.org/2001/XMLSchema-instance" ' +
                         'xmlns:d="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schemas.xmlsoap.org/soap/encoding/" ' +
                         'xmlns:v="http://schemas.xmlsoap.org/soap/envelope/">' +
                         '<v:Header /><v:Body><FindBlankWS xmlns="http://www.bisc.by/webservices" id="o0" c:root="1">' +
                         '<pTB i:type="d:string">%s</pTB><pSB i:type="d:string">%s</pSB><pNB i:type="d:string">%s</pNB>' +
                         '</FindBlankWS></v:Body></v:Envelope>';

  SOAP_ACTION: string = 'http://www.bisc.by/webservices/WEB.WebServ.FindBlankWS';

  MSG_NO_CONNECTION_TITLE: string = 'Соединение отсутствует';
  MSG_NO_CONNECTION_TEXT: string = 'Для проверки необходимо активное подключение к Интернет.'+
                                   ' Подключитесь к сети WiFi или включите передачу мобильных данных и повторите попытку';

  MSG_ERROR_TITLE: string = 'Ошибка';
  MSG_ERROR_TEXT: string = 'Во время запроса сведений произошла ошибка. Попробуйте еще раз';

  MSG_NO_DATA_TITLE: string = 'Сведения отсутствуют';
  MSG_NO_DATA_TEXT: string = 'Сведения не найдены. Проверьте введеные данные и попробуйте еще раз';

  MSG_REQUEST_ERROR_TEXT: string = 'Во время запроса сведений произошла ошибка. Попробуйте еще раз';

  MSG_TOAST: string = 'Нажмите ещё раз для выхода';

implementation

end.

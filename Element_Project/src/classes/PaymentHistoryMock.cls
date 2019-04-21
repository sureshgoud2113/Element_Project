@isTest
public class PaymentHistoryMock implements HttpCalloutMock {
		protected Integer code;
		protected String status;
		protected String bodyAsString;
		protected Blob bodyAsBlob;
		protected Map<String, String> responseHeaders;

		public PaymentHistoryMock(Integer code, String status, String body) {
			this.code = code;
			this.status = status;
			this.bodyAsString = body;
			this.bodyAsBlob = null;
		}

	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse resp = new HttpResponse();
			resp.setStatusCode(code);
            resp.setHeader('Content-Type', 'application/json');
			resp.setStatus(status);
			if (bodyAsBlob != null) {
				resp.setBodyAsBlob(bodyAsBlob);
			} else {
				resp.setBody(bodyAsString);
			}
			return resp;
	    }
}
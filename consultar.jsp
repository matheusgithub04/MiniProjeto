<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.net.*"
    import="java.io.*"
    import="org.json.*"
    import="java.lang.Object.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Consultar</title>
</head>
<body>
	<%
		String numConta = request.getParameter("num_conta");
		String saldo = "";
	
		if(numConta != null) {
			URL url = new URL("http://10.87.203.16:8080/WebService/service");
			
			JSONObject json = new JSONObject();
			json.put("numero_conta", numConta);
			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);
			
			String parametros = "id=2&tipo=2&valores="+json.toString();
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(parametros);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			
			String apnd = "", linha = "";
			
			while((linha = br.readLine()) != null) apnd += linha;
			
			saldo = apnd;
		}
	%>
	
	<form method="post" action="#">
		<input type="text" placeholder="Número da conta" name="num_conta" /><br>
		<button type="submit">Enviar</button><br>
	</form>
	<%
		if(numConta != null) {
			JSONObject obj = new JSONObject(saldo);
			out.print("Seu saldo atual é: "+obj.getString("saldo"));
		}
	%>
</body>
</html>
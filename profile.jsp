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
<title>Perfil de usuário</title>
</head>
<body>
	<%
		String whois = (session.getAttribute("usuario") == null) ? "nobody" : session.getAttribute("usuario").toString(); 
		
	if(!whois.equals("nobody")){
		JSONObject json = new JSONObject(whois);
		String n = json.getString("numero_conta"); 
		json.put("numero_conta", n);
		
		String numConta = request.getParameter("num_conta");
		String saldo = "";
		
		String teste = "teste";
		
		if(teste.equals("teste")){
			URL url = new URL("http://10.87.203.16:8080/WebService/service");
			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);
			
			String parametros = "id=2&tipo=2&valores="+json.toString();
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(parametros);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			
			String apnd = "", linha = "";
			
			while((linha = br.readLine()) != null) apnd += linha;
			
			JSONObject obj = new JSONObject(apnd);
			saldo = obj.getString("saldo");
		}
	%>
	<form method="post" action="#">
		<input type="text" placeholder="Número da conta" name="num_conta" value="<%=n %>" readonly/><br>
		<!-- <button type="submit">Enviar</button><br>  -->
	</form>
	
	<p>Saldo: <%=saldo %></p>
	<%}else{ %>
		<p>Não tem conta logada.</p>
	<%} %>
</body>
</html>
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
<title>Autenticação</title>
</head>
<body>
	<%	String whois = (session.getAttribute("usuario") == null) ? "nobody" : session.getAttribute("usuario").toString(); 
	
		String tipo = request.getParameter("tipo");
		String cpf = request.getParameter("cpf");
		String senhaAcesso = request.getParameter("senhaAcesso");
		String sair = request.getParameter("sair");
		String oi = "";
		
		if(tipo != null){
			if(tipo.equals("6")){
				URL url = new URL("http://10.87.203.16:8080/WebService/service");
				
				JSONObject json = new JSONObject();
				json.put("documento", cpf);
				json.put("senhaAcesso", senhaAcesso);
				
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("POST");
				con.setDoOutput(true);
				
				String parametros = "id=2&tipo=6&valores="+json.toString();
				DataOutputStream wr = new DataOutputStream(con.getOutputStream());
				wr.writeBytes(parametros);
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				
				String apnd = "", linha = "";
				
				while((linha = br.readLine()) != null) apnd += linha;
				
				JSONObject obj = new JSONObject(apnd);
				String nome = obj.getString("nome");
				String numero = obj.getString("numero_conta");
				HttpSession hs = request.getSession();
				hs.setAttribute("usuario", apnd);	
				response.sendRedirect("autenticacao.jsp");
			}else{
				HttpSession hs = request.getSession();
				hs.invalidate();
				response.sendRedirect("autenticacao.jsp");
			}
		}
	%>
		<%
			if(whois.equals("nobody")){
		%>
			<p>BEM-VINDO</p>
			<form method="post" action="#">
				<input type="text" placeholder="CPF" name="cpf" required /><br>
				<input type="text" placeholder="Senha de acesso" name="senhaAcesso" required/><br>
				<input type="hidden" name="tipo" value="6" />
				<button type="submit">Enviar</button><br>
			</form>
		<%}else{%>
			<form method="post" action="#">
				<input type="hidden" name="tipo" value="out" />
				<button type="submit">Sair</button>
			</form>
		<%}%>
		
		<% out.print(cpf); %>
</body>
</html>
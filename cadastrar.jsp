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
<title>Cadastro</title>
</head>
<body>
	<%
		String nome = request.getParameter("nome");
		String cpf = request.getParameter("cpf");
		String dataNasc = request.getParameter("dataNasc");
		String endereco = request.getParameter("endereco");
		String telefone = request.getParameter("telefone");
		String senhaLogin = request.getParameter("senhaLogin");
		String senhaAcesso = request.getParameter("senhaAcesso");
		String recebedor = "";
		
		if( (nome != null) && (cpf != null) && (dataNasc != null) && (endereco != null) && (telefone != null) && (senhaLogin != null) && (senhaAcesso != null) ){
			
			//CRIANDO URL DE CONEXÃO
			URL url = new URL("http://10.87.203.16:8080/WebService/service");
			
			JSONObject json = new JSONObject();
			json.put("nome", nome);
			json.put("cpf", cpf);
			json.put("dataNasc", dataNasc);
			json.put("endereco", endereco);
			json.put("telefone", telefone);
			json.put("senhaLogin", senhaLogin);
			json.put("senhaAcesso", senhaAcesso);
			
			//CRIANDO SESSÃO
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			
			//ALTERNAR ENTRE POST E GET
			con.setRequestMethod("POST");
			
			//HABILITAR ENVIO DE DADOS VIA OUTPUT
			con.setDoOutput(true);
			
			//ENVIANDO INFORMAÇÕES POR POST
			String parametros = "id=2&tipo=1&valores="+json.toString();
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(parametros);
			
			//CRIANDO BUFFER DE LEITURA COM O RETORNO DO SERVLET
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			
			String apnd = "", linha = "";
			
			//LENDO O CONTEUDO OBTIDO DO SERVLET
			while((linha = br.readLine()) != null) apnd += linha;
			recebedor = apnd;
		}
	%>
	
	<form method="post" action="#">
		<input type="text" placeholder="Nome" name="nome" /><br>
		<input type="text" placeholder="CPF" name="cpf" /><br>
		<input type="text" placeholder="Data de nascimento" name="dataNasc" /><br>
		<input type="text" placeholder="Endereço" name="endereco" /><br>
		<input type="text" placeholder="Telefone" name="telefone" /><br>
		<input type="text" placeholder="Senha de login" name="senhaLogin" /><br>
		<input type="text" placeholder="Senha de acesso" name="senhaAcesso" /><br>
		<button type="submit">Enviar</button><br>
	</form>
	<%
		if( (nome != null) && (cpf != null) && (dataNasc != null) && (endereco != null) && (telefone != null) && (senhaLogin != null) && (senhaAcesso != null) ){
			JSONObject obj = new JSONObject(recebedor);
			out.print("Seu número da conta é: "+obj.getString("numero_conta"));
		}
	%>
</body>
</html>
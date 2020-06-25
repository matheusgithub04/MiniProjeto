<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" 
	import="java.net.*" 
	import="java.io.*"
	import="org.json.*" 
	import="java.lang.Object.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>DÉBITO/CRÉDITO</title>
<script src="bootstrap/jquery/dist/jquery.slim.min.js"></script>
<script src="jQuery Mask/jquery.mask.js"></script>
<script src="bootstrap/popper.js/dist/umd/popper.min.js"></script>
<script src="bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="debcrecss.css" />
<link rel="stylesheet" href="bootstrap/dist/css/bootstrap.min.css">
<link rel="icon" type="image/png" href="img/logo.png" />
<style>
body, html {
	height: 100%;
	width: 100%;
	padding: 0;
	margin: 0;
	background-color: #16182f;
	color: white;
}

a:link {
	text-decoration: none;
	color: white;
}

#h4 {
	text-align: center;
	font-weight: normal;
	align-items: center;
}

#h1 {
	text-align: center;
	font-weight: normal;
	align-items: center;
}

.btn {
	background-color: #16182f;
	color: white;
}

.card-header {
	background-color: #16182f;
	color: white;
}

.img {
	width: 100%;
}

</style>
</head>
<body>
	<%
		String numConta = request.getParameter("num_conta");
		String valor = request.getParameter("valor");
		String descricao = request.getParameter("descricao");
		String tipagem = request.getParameter("tipagem");
		int tipo = 0;
		String saldo = "";

		if ((numConta != null) && (valor != null) && (descricao != null) && (tipagem != null)) {
			
			String data1 = request.getParameter("data");
			String data = data1.replace("/", "");
			
			URL url = new URL("http://10.87.203.16:8080/WebService/service");

			JSONObject json = new JSONObject();
			json.put("numero_conta", numConta);
			json.put("data", data);
			json.put("valor", valor);
			json.put("descricao", descricao);

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);

			if (tipagem.equals("debito")) {
				tipo = 3;
			} else {
				tipo = 4;
			}

			String parametros = "id=2&tipo=" + String.valueOf(tipo) + "&valores=" + json.toString();
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(parametros);

			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));

			String apnd = "", linha = "";

			while ((linha = br.readLine()) != null) apnd += linha;
			saldo = apnd;
			JSONObject jon = new JSONObject(apnd);
			
			if(jon.has("cod")){
				int cod = jon.getInt("cod");
				
				if(cod == 301){
					out.print("<script>alert('Saldo insuficiente.')</script>");
				}else{
					out.print("<script>alert('Falha ao inserir.')</script>");
				}
			}else{
				int saldoDebCre = jon.getInt("saldo");
				out.print("<script>alert('Seu saldo atual é: "+saldoDebCre+"')</script>");
			}
		}

		String nb = "nobody";
		String whois = (session.getAttribute("usuario") == null) ? "{\"nobody\":"+nb+"}" : session.getAttribute("usuario").toString();
		if(whois.equals("{\"nobody\":"+nb+"}")){ %>
		<p class="text-center pt-3"><a href="home.jsp">LOGUE</a> EM SUA CONTA.</p>
		<%}else{ %>
	<header>
		<nav class="navbar navbar-default">
			<div class="navbar-header">
				<a class="img" href="home.jsp" title="SmartBank"><img
					src="img/logot.png"></a>
			</div>
		</nav>
	</header>

	<h1 class="text-white" id="h1">Débito e Crédito</h1>
	<h4 class="text-white" id="h4">SmartBank in a Box - uma plataforma bancária completa com infinitas possibilidades.</h4>
	<br>

		<div class="container">
			<div class="card">
				<div class="card-header">Fazer ação</div>
				<div class="card-body">

					<form method="post" action="#">
						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<label class="input-group-text" for="inputGroupSelect01">Opções</label>
							</div>
							 <select required name="tipagem" class="custom-select" id="inputGroupSelect01" >
								<option selected disabled>Escolher...</option>
								<option value="debito">Débito</option>
								<option value="credito">Crédito</option>
							</select>
							<!-- <input type="radio" name="tipagem" value="debito">
							<label class="text-dark" for="male">Débito</label><br>
							<input type="radio" name="tipagem" value="credito">
							<label class="text-dark" for="female">Crédito</label><br>-->
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text" id="inputGroup-sizing-default">Número da conta</span>
							</div>
							<% JSONObject jn = new JSONObject(whois);%>
							<input type="text" class="form-control" readonly aria-describedby="inputGroup-sizing-default" name="num_conta" value="<%=jn.getString("numero_conta") %>" required>
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text" id="inputGroup-sizing-default">Data</span>
							</div>
							<input id="data" type="text" class="form-control" aria-describedby="inputGroup-sizing-default" name="data" required>
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text">R$</span>
							</div>
							<input type="text" class="form-control"
								aria-label="Quantia em Dollar (com ponto e duas casas decimais)" name="valor" required>
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text" id="inputGroup-sizing-default">Descrição</span>
							</div>
							<input type="text" class="form-control" aria-describedby="inputGroup-sizing-default" name="descricao">
						</div>
						<button type="submit" class="btn btn-outline-dark">Enviar</button>
					</form>
				</div>
			</div>
		</div>

		<br> <br>
			<div class="row">
				<div class="col-3"></div>
				<div class="col-6">
					<a type="button" href="home.jsp" class="btn btn-outline-dark btn-lg btn-block text-center">Home</a>
				</div>
			</div>
			
		 <br> <br>

		<section class="section section-text" data-id="2" data-type="text">
			<div class="container">
				<div class="ckeditor" id="ckeditor2">
					<h1 style="text-align: center">
						<br>
						<br>É banco ou startup?<br>
						<br>
					</h1>
					<p style="text-align: center">
						<span style="color: #696969">
							<h5>Juntamos o melhor dos dois! Costumamos dizer que o
								SmartBank tem segurança de banco e agilidade de fintech. Isso
								porque possui uma infraestrutura bancária completa, aprovada
								pelo Banco Central, e seu DNA tem como base tecnologias como Big
								Data e Inteligência Artificial.</h5>
						</span>
					</p>
					<p style="text-align: center">
						<span style="color: #696969">
							<h5>Foi a sinergia entre solidez e dinamismo que permitiu a
								criação de uma plataforma bancária 100% digital. Essa é uma nova
								experiência financeira com o propósito de apoiar quem empreende
								e administra suas próprias empresas, a partir de produtos mais
								flexíveis, eficientes e acessíveis.</h5>
						</span>
					</p>
					<p style="text-align: center">
						<span style="color: #696969">
							<h5>A integração entre a inteligência humana e da tecnologia
								permite construir soluçõµes transparentes e transformadoras com
								clientes e parceiros, contribuindo para potencializar muitos
								crescimentos: de cada negócio envolvido, da economia â€‹do Brasil,
								da nossa sociedade e de todos os indivíduos que fazem parte
								dessa história.</h5>
						</span>
					</p>
					<h3 style="text-align: center">
						<br>
						<br>
					</h3>
					<p style="text-align: center">
						<br>
					</p>
				</div>
			</div>
		</section>

		<br>

		<footer class="page-footer font-small blue">
			<div class="footer-copyright text-center py-3">
				© 2020: <a href="home.jsp"> SmartBank.com</a>
			</div>
		</footer>
		<%} %>
		
		<%
			//if ((numConta != null) && (valor != null) && (descricao != null)) {
				//JSONObject obj = new JSONObject(saldo);
				//out.print("<script>alert('Seu saldo atual é: "+obj.getInt("saldo")+"')</script>");
			//}
		%>
		
	<script src="debcrejs.js"></script>
</body>
</html>
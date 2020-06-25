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
<title>EXTRATO</title>
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
		String nb = "nobody";
		String whois = (session.getAttribute("usuario") == null) ? "{\"nobody\":"+nb+"}" : session.getAttribute("usuario").toString();
		JSONObject j = new JSONObject(whois);
		
		String numConta = request.getParameter("num_conta");
		String inicioData1 = request.getParameter("inicio_periodo");
		String fimData1 = request.getParameter("fim_periodo");
		String recebedor = "";	
	
		if(numConta != null) {
			String inicioData = inicioData1.replace("/", "");
			String fimData = fimData1.replace("/", "");
			
			URL url = new URL("http://10.87.203.16:8080/WebService/service");
			
			JSONObject json = new JSONObject();
			json.put("numero_conta", numConta);
			json.put("inicio_periodo", inicioData);
			json.put("fim_periodo", fimData);
			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);
			
			String parametros = "id=2&tipo=7&valores="+json.toString();
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(parametros);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			
			String apnd = "", linha = "";
			
			while((linha = br.readLine()) != null) apnd += linha;
			recebedor = apnd;
			
		}
	
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

	<h1 class="text-white" id="h1">Extrato</h1>
	<br>

		<div class="container">
			<div class="card">
				<div class="card-body">

					<form method="post" action="#">
						<div class="input-group mb-3">
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text" id="inputGroup-sizing-default">Número da conta</span>
							</div>
							
							<input type="text" class="form-control" readonly aria-describedby="inputGroup-sizing-default" name="num_conta" required value="<%= j.getString("numero_conta") %>">
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text" id="inputGroup-sizing-default">Data de início</span>
							</div>
							<input id="inicio_periodo" type="text" class="form-control" aria-describedby="inputGroup-sizing-default" name="inicio_periodo" required>
						</div>

						<div class="input-group mb-3">
							<div class="input-group-prepend">
								<span class="input-group-text">Data de fim</span>
							</div>
							<input id="fim_periodo" type="text" class="form-control"
								aria-label="Quantia em Dollar (com ponto e duas casas decimais)" name="fim_periodo" required>
						</div>
						<button type="submit" class="btn btn-outline-dark">Enviar</button>
					</form>
				</div>
			</div>
		</div>

		<br><br><br>

		<div style="display: grid; grid-template-columns: 1fr 1fr 1fr;">
			<%
				if(numConta != null) {
					JSONArray arr = new JSONArray(recebedor);
					
					for(int i = 0; i < arr.length(); i++){
						JSONObject ob = arr.getJSONObject(i);
			%>
						<div class="col mt-3 d-flex justify-content-center">
							<div class="card" style="width: 18rem; ">
							  <div class="card-body">
							    <h5 class="card-title text-dark">Número da conta: <%= ob.getString("numero_conta") %></h5>
							    
							    <% String tipo =  ob.getString("tipo");%>
							    <h6 class="card-subtitle mb-2 text-muted"> <%=tipo  %></h6>
							    <p class="card-text text-dark"> <%= ob.getString("descricao") %></p>
							    <%if(tipo.equals("CR")){ %>
							    	<p class="card-link text-primary">R$  <%= ob.getString("valor") %></p>
							    <%}else{ %>
							    	<p class="card-link text-danger">R$  <%= ob.getString("valor") %></p>
							    <%} %>
							  </div>
						  	</div>
				  		</div>
			<%
					}
				}
			%>
		</div>		
	<%
		}
	%>
	<script src="extratojs.js"></script>
</body>
</html>
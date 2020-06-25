<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.net.*" import="java.io.*"
	import="org.json.*" import="java.lang.Object.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>TRANSFERÊNCIA</title>
<script src="bootstrap/jquery/dist/jquery.slim.min.js"></script>
<script src="jQuery Mask/jquery.mask.js"></script>
<script src="bootstrap/popper.js/dist/umd/popper.min.js"></script>
<script src="bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="transferenciacss.css" />
<link rel="stylesheet" href="bootstrap/dist/css/bootstrap.min.css">
<link rel="icon" type="image/png" href="img/logo.png" />
</head>
<style>
a:link{
	text-decoration: none;
}
</style>
<body class="conteudo">
	<%
		String nb = "nobody";
		String whois = (session.getAttribute("usuario") == null) ? "{\"nobody\":"+nb+"}" : session.getAttribute("usuario").toString();
		JSONObject j = new JSONObject(whois);
		String saldo = "";
		String conta_origem = request.getParameter("conta_origem");
		String conta_destino = request.getParameter("conta_destino");		
		String valor = request.getParameter("valor");
		
		if ((conta_origem != null) && (conta_destino != null) && (valor != null)) {
			String data = request.getParameter("data");
			String data1 = data.replace("/", ""); 
			
			URL url = new URL("http://10.87.203.16:8080/WebService/service");

			JSONObject json = new JSONObject();
			json.put("conta_origem", conta_origem);
			json.put("conta_destino", conta_destino);
			json.put("data", data1);
			json.put("valor", valor);

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);

			String parametros = "id=2&tipo=5&valores=" + json.toString();
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
				int saldoTrans = jon.getInt("saldo");
				out.print("<script>alert('Transferência feita com sucesso. Saldo atual: "+saldoTrans+"')</script>");
			}
		}
		
	String tipo = request.getParameter("tipo");
		
		if(tipo != null){
			if(tipo.equals("6")){
				URL url = new URL("http://10.87.203.16:8080/WebService/service");
				
				String cpf = request.getParameter("cpf");
				String cpf1 = cpf.replace(".", "");
				String cpfzao = cpf1.replace("-", "");
				
				String senhaAcesso = request.getParameter("senhaAcessoLogin");
				String sair = request.getParameter("sair");
				
				JSONObject json = new JSONObject();
				json.put("documento", cpfzao);
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
				response.sendRedirect("home.jsp");
			}else{
				HttpSession hs = request.getSession();
				hs.invalidate();
				response.sendRedirect("home.jsp");
			}
		}
		
		String tipagem = request.getParameter("tipagem");
		String recebedor = "";
		
		if(tipagem != null){
			String nome = request.getParameter("nome");
			
			String cpf = request.getParameter("cpf");
			String cpf1 = cpf.replace(".", "");
			String cpfzao = cpf1.replace("-", "");
			
			String dataNasc = request.getParameter("dataNasc");
			String dataNasc1 = dataNasc.replace("/", "");
			
			String endereco = request.getParameter("endereco");
			
			String telefone = request.getParameter("telefone");
			String tel1 = telefone.replace("(", "");
			String tel2 = tel1.replace(")", "");
			String tel3 = tel2.replace("-", "");
			String tel4 = tel3.replace(" ", "");
			String tel5 = tel4.replace(" ", "");
			
			String senhaLogin = request.getParameter("senhaLogin");
			String senhaAcesso = request.getParameter("senhaAcesso");
			
			if( (nome != null) && (cpf != null) && (dataNasc != null) && (endereco != null) && (telefone != null) && (senhaLogin != null) && (senhaAcesso != null) ){
				URL url = new URL("http://10.87.203.16:8080/WebService/service");
				
				JSONObject json = new JSONObject();
				json.put("nome", nome);
				json.put("cpf", cpfzao);
				json.put("dataNasc", dataNasc1);
				json.put("endereco", endereco);
				json.put("telefone", tel5);
				json.put("senhaLogin", senhaLogin);
				json.put("senhaAcesso", senhaAcesso);
				
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("POST");
				con.setDoOutput(true);
				
				String parametros = "id=2&tipo="+tipagem+"&valores="+json.toString();
				DataOutputStream wr = new DataOutputStream(con.getOutputStream());
				wr.writeBytes(parametros);
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				
				String apnd = "", linha = "";
	
				while((linha = br.readLine()) != null) apnd += linha;
				
				JSONObject jon = new JSONObject(apnd);
				
				if(jon.has("cod")){
					
					int codwrong= jon.getInt("cod");
					
					if(codwrong == 301){
						out.print("<script>Saldo insuficiente.')</script>");
					}else{
						out.print("<script>Falha ao inserir .')</script>");
					}
				}
			}
		}
	%>
	<div class="navConteudo">
		<%if(whois.equals("{\"nobody\":"+nb+"}")){ %>
			<p class="text-center pt-3 text-white"><a href="home.jsp">LOGUE</a> EM SUA CONTA.</p>
		<%}else{ %>
		<nav class="navbar navbar-expand-lg navbar-light" id="Letreiro">
			<a href="home.jsp"><img src="img/logot.png" id="imgNav"
				width="390px" height="90px"></a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<div class="form-inline ml-auto">
					<div class="dropdown show">
						<!-- <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
							role="button" data-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false;"> Mais </a>
						<div class="dropdown-menu" aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="debcre.jsp">Débito e Crédito</a>
							<a class="dropdown-item" href="transferencia.jsp">Transferência</a>
							<a class="dropdown-item" href="extrati.jsp">Consultar
								extrato</a>
						</div> -->
					</div>

					<!-- Modal -->
					<div class="modal fade" id="ModalCadastro" tabindex="-1"
						role="dialog">
						<div class="modal-dialog modal-dialog-centered modal-lg">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title">Faça seu cadastro</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<form method="post" action="#">
									<div class="modal-body cadastroModal">
										<div class="form-group divNome">
											<div class="nome1">
												<label class="mr-auto">Nome</label> <input id="inputNome"
													class="form-control" name="nome" maxlength="152" required />
											</div>
										</div>

										<div class="form-group divCpf">
											<div class="cpf1">
												<label class="mr-auto">CPF</label> <input id="inputCpf"
													class="form-control col-11" name="cpf" required />
											</div>
										</div>

										<div class="form-group divDatNasc">
											<div class="dataNasc1">
												<label class="mr-auto">Data de nascimento</label> <input
													id="inputNasc" class="form-control col-11" name="dataNasc"
													required />
											</div>
										</div>

										<div class="form-group divEndereco">
											<div class="endereco1">
												<label class="mr-auto">Endereço</label> <input
													id="inputEndereco" class="form-control col-11"
													name="endereco" required />
											</div>
										</div>

										<div class="form-group divTelefone">
											<div class="telefone1">
												<label class="mr-auto">Telefone</label> <input
													id="inputTelefone" class="form-control col-11"
													name="telefone" required />
											</div>
										</div>

										<div class="form-group divSenhaAcesso">
											<div class="acesso1">
												<label class="mr-auto">Senha de acesso</label> <input
													type="password" id="inputAcesso" class="form-control col-11"
													name="senhaAcesso" required maxlength="6" />
											</div>
										</div>

										<div class="form-group divSenhaLogin">
											<div class="login1">
												<label class="mr-auto">Senha de login</label> <input
													type="password" id="inputLogin" class="form-control col-11"
													name="senhaLogin" required minlength="8" maxlength="16" />
											</div>
										</div>
										<input type="hidden" name="tipagem" value="1" />
									</div>
									<div class="modal-footer">
										<button type="submit" class="cadas">Cadastrar</button>
									</div>
								</form>
							</div>
						</div>
					</div>

					<div>
						<%if(whois.equals("{\"nobody\":"+nb+"}")){ %>
							<form method="post" action="#">
								<input name="cpf" id="cpf" class="text-center form-control m-2"
									placeholder="CPF" required /> <input name="senhaAcessoLogin" type="password"
									class="text-center form-control m-2"
									placeholder="Senha de acesso" required />
									<input type="hidden" name="tipo" value="6"/>
								<button type="submit" class="btn btn-outline-light form-control m-2 btnLogin">Entrar</button>
							</form>
						<%}else{ %>
							<form method="post" action="#">
								<input type="hidden" name="tipo" value="out" />
								<button type="submit" class="btn btn-outline-light form-control m-2">Sair</button>
							</form>
						<%} %>	
					</div>
					<%if(whois.equals("{\"nobody\":"+nb+"}")){ %>
					<button type="button" class="btn btn-outline-light form-control ml-auto" data-toggle="modal" data-target="#ModalCadastro" id="Letreiro">Cadastre-se</button>
					<%} %>
				</div>
			</div>
		</nav>
	</div>

	<div class="partTrans mt-2">
		<form class="divTrans" method="post" action="#">
			<div class="form-group">
				<label id="cntOrg" class="text-white">Informe a conta de origem</label> 
				<% JSONObject jo = new JSONObject(whois); %>
				<input id="cntOrigem" class="form-control" type="text" placeholder="Conta origem" name="conta_origem" readonly value="<%=jo.getString("numero_conta") %>" required/>
			</div>
			<div class="form-group">
				<label class="text-white">Informe a conta de destino</label> 
				<input id="cntDestino" class="form-control" type="text" placeholder="Conta destino" name="conta_destino" required/>
			</div>
			<div class="form-group">
				<label class="text-white">Informe a data para a transferência</label> 
				<input id="data" class="form-control" type="text" placeholder="Data" name="data" required/>
			</div>
			<div class="form-group">
				<label class="text-white">Informe o valor da transferência</label> 
				<input id="valor" class="form-control" type="text" placeholder="Valor" name="valor" required/>
			</div>
			<button id="btntrans" class="form-control btn btn-primary"
				type="submit">Enviar</button>
		</form>
	</div>

	<script src="transferenciajs.js"></script>
	<%
		if ((conta_origem != null) && (conta_destino != null) && (valor != null)) {
			JSONObject obj = new JSONObject(saldo);
	%>
			<script>
			//var booleana = confirm("Transferência feita com sucesso.");
			//booleana;
			//if(booleana == true){
				//window.location.href = 'home.jsp';
			//}
			</script>
	<%
		}
	}
	%>
	
</body>
</html>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
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
<title>PÁGINA INICIAL</title>
<script src="bootstrap/jquery/dist/jquery.slim.min.js"></script>
<script src="jQuery Mask/jquery.mask.js"></script>
<script src="bootstrap/popper.js/dist/umd/popper.min.js"></script>
<script src="bootstrap/dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="homecss.css" />
<link rel="stylesheet" href="bootstrap/dist/css/bootstrap.min.css">
<link rel="icon" type="image/png" href="img/logo.png" />
<style>
.celular {
	position: relative;
	display: block;
	margin-left: auto;
	margin-right: auto;
}

a:link {
	text-decoration: none;
}

.celular .screen {
	position: absolute;
	top: 0;
	left: 0;
	transition: 0.5s;
}

.celular:hover .screen.screen5 {
	transform: translateY(-160px);
	opacity: 1;
}

.celular:hover .screen.screen4 {
	transform: translateY(-1);
	opacity: .8;
}

.celular:hover .screen.screen3 {
	transform: translateY(-80px);
	opacity: .6;
}

.celular:hover .screen.screen2 {
	transform: translateY(-40px);
	opacity: .4;
}

.celular:hover .screen.screen1 {
	transform: translateY(0px);
	opacity: .2;
}
</style>
</head>
<body class="conteudo">
	<%
		String nb = "nobody";
		String whois = (session.getAttribute("usuario") == null) ? "{\"nobody\":"+nb+"}" : session.getAttribute("usuario").toString();
		JSONObject j = new JSONObject(whois);
		String saldo = "";

		if(!whois.equals("{\"nobody\":"+nb+"}")){
			String n = j.getString("numero_conta");
			j.put("numero_conta", n);
			
			String teste = "teste";
			
			if(teste.equals("teste")){
				URL url = new URL("http://10.87.203.16:8080/WebService/service");
				
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("POST");
				con.setDoOutput(true);
				
				String parametros = "id=2&tipo=2&valores="+j.toString();
				DataOutputStream wr = new DataOutputStream(con.getOutputStream());
				wr.writeBytes(parametros);
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				
				String apnd = "", linha = "";
				
				while((linha = br.readLine()) != null) apnd += linha;
				
				JSONObject obj = new JSONObject(apnd);
				saldo = obj.getString("saldo");
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
				
				JSONObject jon = new JSONObject(apnd);
				
				if(jon.has("cod")){
					int cod = jon.getInt("cod");
					
					if(cod == 101){
						out.print("<script>alert('Parâmetros fora do escopo.')</script>");
					}else if(cod == 102){
						out.print("<script>alert('Senha de acesso invalida.')</script>");
					}else if(cod == 103){
						out.print("<script>alert('CPF Inválido.')</script>");
					}else if(cod == 104){
						out.print("<script>alert('Data inválida.')</script>");
					}else if(cod == 105){
						out.print("<script>alert('Falha ao inserir.')</script>");
					}else if(cod == 106){
						out.print("<script>alert('CPF inválido.')</script>");
					}else if(cod == 001){
						out.print("<script>alert('Tipo não informado.')</script>");
					}else if(cod == 002){
						out.print("<script>alert('Valores não recebidos.')</script>");
					}else if(cod == 003){
						out.print("<script>alert('ID não informado.')</script>");
					}else if(cod == 007){
						out.print("<script>alert('Campo não encontrado.')</script>");
					}else{
						out.print("<script>alert('Conta não existe.')</script>");
					}
				}else{
					String nome = jon.getString("nome");
					String numero = jon.getString("numero_conta");
					HttpSession hs = request.getSession();
					hs.setAttribute("usuario", apnd);	
					response.sendRedirect("home.jsp");
				}
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
					int cod = jon.getInt("cod");
					
					if(cod == 101){
						out.print("<script>alert('Parâmetros fora do escopo.')</script>");
					}else if(cod == 102){
						out.print("<script>alert('Senha de acesso invalida.')</script>");
					}else if(cod == 103){
						out.print("<script>alert('CPF Inválido.')</script>");
					}else if(cod == 104){
						out.print("<script>alert('Data inválida.')</script>");
					}else if(cod == 105){
						out.print("<script>alert('Falha ao inserir.')</script>");
					}else if(cod == 106){
						out.print("<script>alert('CPF inválido.')</script>");
					}else if(cod == 001){
						out.print("<script>alert('Tipo não informado.')</script>");
					}else if(cod == 002){
						out.print("<script>alert('Valores não recebidos.')</script>");
					}else if(cod == 003){
						out.print("<script>alert('ID não informado.')</script>");
					}else if(cod == 007){
						out.print("<script>alert('Campo não encontrado.')</script>");
					}else{
						out.print("<script>alert('Conta não existe.')</script>");
					}
				}else{
					out.print("<script>alert('Número da sua conta é: "+jon.getString("numero_conta")+". Anote-a ou logue para saber sua conta.')</script>");
				}
			}
		}
	%>
	<div class="navConteudo pb-4">
		<nav class="navbar navbar-expand-lg navbar-light" id="Letreiro">
			<a href="home.jsp"><img src="img/logot.png" id="imgNav"
				width="390px" height="90px"></a>
			<button class="navbar-toggler btn btn-light" type="button" data-toggle="collapse"
				data-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon btn btn-light bg-light"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<div class="form-inline ml-auto">
					<div class="dropdown show">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
							role="button" data-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false;" style="text-decoration: none;">
							Navegue </a>
						<div class="dropdown-menu" aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="debcre.jsp">Débito e Crédito</a>
							<a class="dropdown-item" href="transferencias.jsp">Transferência</a>
							<a class="dropdown-item" href="extrato.jsp">Consultar
								extrato</a>
							<a class="dropdown-item" href="pagarboleto.jsp">Pagamento de boleto</a>	
						</div>
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
													name="senhaAcesso" required minlength="6" maxlength="6"/>
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
									placeholder="Senha de acesso" required minlength="6" maxlength="6" />
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

	<%if(whois.equals("{\"nobody\":"+nb+"}")){ %>
	<div class="partHome pt-4">
		<div class="divHome m-auto">
			<img src="img/background (1).svg" height="800" width="1200">
		</div>
	</div>

	<br>
	<br>
	<br>
	<br>

	<div class="partHome1 pt-4 pb-4">
		<div class="celular m-auto">
			<img src="img/iphone700px.png" class="rounded mx-auto d-block"
				height="250" height="250"> <img src="img/screen.png"
				class="screen screen1 rounded mx-auto d-block" height="250"
				height="250"> <img src="img/screen.png"
				class="screen screen2 rounded mx-auto d-block" height="250"
				height="250"> <img src="img/screen.png"
				class="screen screen3 rounded mx-auto d-block" height="250"
				height="250"> <img src="img/screen.png"
				class="screen screen4 rounded mx-auto d-block" height="250"
				height="250"> <img src="img/screen.png"
				class="screen screen5 rounded mx-auto d-block" height="250"
				height="250">
		</div>
		<div class="msgnCel m-auto text-center pr-2">
			<p style="color: whitesmoke;">
				Conheça nosso aplicativo e tenha um acesso seguro e prático para
				fazer a gestão da sua conta. Facilite sua vida Baixe já!<br>
				Disponivel na PlayStore e AppleStore.
			</p>
		</div>
	</div>
	<%}else{ %>
		<div class="container pt-5">
			<div class="card">
				<div class="card-header text-center" style="background-color: #4794e0; color: white; border: 1px solid-transparent #4794e0">INFORMAÇÕS DA CONTA</div>
				<div class="card-body">
					<div class="row">
						<div class="card col-5 mb-2 ml-5 pl-0 pr-0 m-auto">
							<div class="card-header">Nome:</div>
							<div class="card-body">
								<p> <%=j.getString("nome") %></p>
							</div>
						</div>
						<div class="col-1"></div>
						<div class="card col-5 mb-2 pl-0 pr-0 m-auto">
							<div class="card-header">Endereço:</div>
							<div class="card-body">
								<p> <%=j.getString("endereco") %></p>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="card col-5 mb-2  ml-5 pl-0 pr-0 m-auto">
							<div class="card-header">Data de nascimento:</div>
							<div class="card-body">
								<% String[] datNasc = j.getString("dataNasc").split("-"); %>
								<p> <%=datNasc[2]+"/"+datNasc[1]+"/"+datNasc[0] %></p>
							</div>
						</div>
						<div class="col-1"></div>
						<div class="card col-5 mb-2 pl-0 pr-0 m-auto">
							<div class="card-header">Telefone:</div>
							<div class="card-body">
								<% String[] telEdit = j.getString("telefone").split(""); %>
								<p>(<%=telEdit[0]+""+telEdit[1]%>) <%=telEdit[2] %> <%=telEdit[3]+""+telEdit[4]+""+telEdit[5]+""+telEdit[6] %>-<%=telEdit[7]+""+telEdit[8]+""+telEdit[9]+""+telEdit[10] %></p>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="card col-5 mb-2  ml-5 pl-0 pr-0 m-auto">
							<div class="card-header">Número da conta:</div>
							<div class="card-body">
								<p> <%=j.getString("numero_conta") %></p>
							</div>
						</div><br>
						<div class="col-1"></div>
						<div class="card col-5 mb-2 mt-2 pl-0 pr-0 m-auto">
							<div class="card-header">Saldo:</div>
							<div class="card-body">
								<p>R$ <%=saldo %></p>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</div><br>
		<style>
			#cliente{
				display: grid;
				grid-template-columns: 1fr 1fr 1fr 1fr;
				grid-template-rows: 1fr 1fr;
			}
			
			#botao1{
				grid-column-start: 2;
				grid-column-end: 2;
			}
			
			#botao2{
				grid-column-start: 3;
				grid-column-end: 3;
			}
		
		</style>
		<div>
			<div id="cliente">
				<div id="botao1" class="col mb-2"><a href="debcre.jsp"><button class="btn btn-outline-primary btn-lg btn-block">Débito/Crédito</button></a></div>
				<div id="botao2" class="col mb-2"><a href="transferencias.jsp"><button class="btn btn-outline-primary btn-lg btn-block">Transferência</button></a></div>
				<div id="botao1" class="col mb-2"><a href="pagarboleto.jsp"><button class="btn btn-outline-primary btn-lg btn-block">Pagar boleto</button></a></div>
				<div id="botao2" class="col mb-2"><a href="extrato.jsp"> <button class="btn btn-outline-primary btn-lg btn-block">Extrato</button></a></div>
			</div>
		</div>
		
		
		
		<br>
		<br>
		<br>
		
	<%} %>
	<%if(whois.equals("{\"nobody\":"+nb+"}")){ %>
	<div class="footer text-white pt-4">
		<footer class="page-footer font-small mdb-color pt-4">
			<div class="container text-center text-md-left">
				<div class="row text-center text-md-left mt-3 pb-3">
					<div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
						<h6 class="text-uppercase mb-4 font-weight-bold">SmartBank</h6>
						<p>Temos estrutura bancária completa e aprovada pelo Banco
							Central, além de mais de 50 anos de história, que possui
							executivos com grande história e notoriedade no mercado
							financeiro brasileiro.</p>
					</div>

					<hr class="w-100 clearfix d-md-none">

					<div class="col-md-2 col-lg-2 col-xl-2 mx-auto mt-3">
						<h6 class="text-uppercase mb-4 font-weight-bold">Produtos</h6>
						<p>
							<a href="transferencia.html" class="text-white"
								style="text-decoration: none;">Transferências</a>
						</p>
						<p>
							<a href="debcre.html" class="text-white"
								style="text-decoration: none;">Débito</a>
						</p>
						<p>
							<a href="debcre.html" class="text-white"
								style="text-decoration: none;">Crédito</a>
						</p>
					</div>

					<hr class="w-100 clearfix d-md-none">

					<div class="col-md-3 col-lg-2 col-xl-2 mx-auto mt-3">
						<h6 class="text-uppercase mb-4 font-weight-bold">Parceiros</h6>
						<p>
							<a href="https://banco.bradesco/html/classic/index.shtm"
								class="text-white" style="text-decoration: none;">Bradesco</a>
						</p>
						<p>
							<a href="https://www.bb.com.br/pbb/pagina-inicial"
								class="text-white" style="text-decoration: none;">Banco do
								Brasil</a>
						</p>
					</div>
	<%} %>
					<hr class="w-100 clearfix d-md-none">

					<div class="col-md-4 col-lg-3 col-xl-3 mx-auto mt-3 text-white">
						<h6 class="text-uppercase mb-4 font-weight-bold">Contatos</h6>
						<p>
							<i></i> Rua Otarios Lendo, SP 092, BR
						</p>
						<p>
							<i></i> smartbank@gmail.com
						</p>
						<p>
							<i></i> 55 19 9 1234-5678
						</p>
						<p>
							<i></i> 55 19 9 8765-4321
						</p>
					</div>

				</div>

				<hr>
	
				<div class="row d-flex align-items-center">
					<div class="col-md-7 col-lg-8"></div>

					<div class="col-md-5 col-lg-4 ml-lg-0">
						<div class="text-center text-md-right">
							<ul class="list-unstyled list-inline">
								<li class="list-inline-item"><a
									class="btn-floating btn-sm rgba-white-slight mx-1"> <i
										class="fab fa-facebook-f"></i>
								</a></li>
								<li class="list-inline-item"><a
									class="btn-floating btn-sm rgba-white-slight mx-1"> <i
										class="fab fa-twitter"></i>
								</a></li>
								<li class="list-inline-item"><a
									class="btn-floating btn-sm rgba-white-slight mx-1"> <i
										class="fab fa-google-plus-g"></i>
								</a></li>
								<li class="list-inline-item"><a
									class="btn-floating btn-sm rgba-white-slight mx-1"> <i
										class="fab fa-linkedin-in"></i>
								</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</footer>
	</div>
	
	<script src="homejs.js"></script>
</body>
</html>
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
    <title>BOLETO</title>
    <script src="bootstrap/jquery/dist/jquery.slim.min.js"></script>
	<script src="jQuery Mask/jquery.mask.js"></script>
	<script src="bootstrap/popper.js/dist/umd/popper.min.js"></script>
	<script src="bootstrap/dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="bootstrap/dist/css/bootstrap.min.css">
    <link rel="shortcut icon" href="img/logo.png">
    <style>
    	body, html {
			height: 100%;
			width: 100%;
			padding: 0;
			margin: 0;
			background-color: #16182f;
			color: white;
		}
  	
        .page-footer {
            background-color: #16182f;
            color: white;
        }

        #h4 {
            text-align: center;
            font-weight: normal;
            color: #80bfff;
            align-items: center;
        }

        #h1 {
            text-align: center;
            font-weight: normal;
            color: #16182f;
            align-items: center;
        }

        .btn {
            background-color: #16182f;
            color: white;
        }

        img {
            max-width: 100%;
            height: auto;
        }
        .page-footer{
            max-width: 1300%;
            margin: auto;
            padding: 0 20px;
        }
        a:link{
        	text-decoration: none;
        	color: white;
        }
    </style>
<body class="body">
	<%
		String nb = "nobody";
		String whois = (session.getAttribute("usuario") == null) ? "{\"nobody\":"+nb+"}" : session.getAttribute("usuario").toString();
		JSONObject j = new JSONObject(whois);
		String cod = request.getParameter("cod");
		String saldo = "";

		if(cod != null) {
			String[] cd = cod.split("");
			
			if(cd.length >=18){
				String ag = cd[0]+""+cd[1];
				String acc = cd[2]+""+cd[3]+""+cd[4]+""+cd[5];
				String data = cd[6]+""+cd[7]+""+cd[8]+""+cd[9]+""+cd[10]+""+cd[11]+""+cd[12]+""+cd[13];
	
				String dinheiro = "";
				String cents = "";
	
				cents = "."+cd[cd.length-2]+""+cd[cd.length-1];
	
				for(int i = 14; i <cd.length-2; i++){
				    dinheiro += cd[i]+"";
				}
				
				String total = dinheiro+""+cents;
				String descricao = "Pagamento de boleto.";
				
				URL url = new URL("http://10.87.203.16:8080/WebService/service");
	
				JSONObject json = new JSONObject();
				json.put("numero_conta", j.getString("numero_conta"));
				json.put("data", data);
				json.put("valor", total);
				json.put("descricao", descricao);
	
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("POST");
				con.setDoOutput(true);
	
				String parametros = "id=2&tipo=3&valores=" + json.toString();
				DataOutputStream wr = new DataOutputStream(con.getOutputStream());
				wr.writeBytes(parametros);
	
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	
				String apnd = "", linha = "";
	
				while ((linha = br.readLine()) != null) apnd += linha;
	
				saldo = apnd;
				
				JSONObject jon = new JSONObject(apnd);
				
				if(jon.has("cod")){
					int codwrong= jon.getInt("cod");
					
					if(codwrong == 301){
						out.print("<script>alert('Saldo insuficiente.')</script>");
					}else{
						out.print("<script>alert('Falha ao inserir.')</script>");
					}
				}else{
					out.print("<script>alert('Boleto pago com sucesso.')</script>");
				}
			}else{
				out.print("<script>alert('Código de barra inválido.')</script>");
			}
		}
		if(whois.equals("{\"nobody\":"+nb+"}")){%>
		<p class="text-center pt-4"><a href="home.jsp">LOGUE</a> EM SUA CONTA.</p>
		<%}else{ %>
    <header>
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">

                    <div class="container-company-img">
                        <a href="home.jsp" title="SmartBank">
                            <img src="img/logot.png"
                                title="SmartBank" alt="SmartBank" class="header-image"></a>
                    </div>
                </div>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav primary-nav navbar-menu">
                        <li class="no-mobile">
                            <a href="https://portal.kenoby.com/smartbank/dashboard" title="#" target="_blank">
                                <img alt="Avatar candidato" src="/assets/images/avatar-empty.png" class="img-avatar">
                                <span class="blue-text">Sou Candidato</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

        <br>
        <br> 
        <br>
        <br>
        <br>
        <br>
        <br>
        

        <div class="container text-dark">
            <div class="card">
                <div class="card-header">
                    Leitor de Código
                </div>
                <div class="card-body">

                    <h5 class="card-title">Insira o Código de barras:</h5>
                    <p class="card-text"></p>
                    <form method="post" action="#">                                      
                        <div class="form-group">

                            <input name="cod" type="text" class="form-control" id="formGroupExampleInput"
                                placeholder="Ex: 7898240280497" required >
                        </div>
                        <button type="submit" class="btn btn-outline-dark">Enviar</button>
                    </form>
                </div>
            </div>
        </div>
       
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        
        <footer class="page-footer font-small blue">

            <div class="footer-copyright text-center py-3">© 2020:
                <a href="home.jsp">SmartBank.com</a>
            </div>

        </footer>
       	<%}%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">		
	</head>	
	<body>
		
		 	<nav>
				<ul>
					<li><a href="index.jsp?page=0">Accueil</a></li>
					<li><a href="about.jsp">A propos</a></li>
				</ul>
			</nav>
		<style>
			nav {
			  margin:0;
			  padding:0;
			  display: flex;
			  justify-content:center;
			  align-items:center;
			  height:12vh;
			  background:#112c38;
			}
			
			nav ul{
			  margin:0;
			  padding:0;
			  display:flex;
			  justify-content:center;
			}
			
			nav ul li{
			  list-style:none;
			  margin:0 20px;
			  transition:0.5s;
			  text-align:center;
			}
			
			nav ul li a{
			  display: block;
			  position:relative;
			  
			  text-decoration:none;
			  padding:30px;
			  font-size:18px;
			  font-family: sans-serif;
			  color:#fff;
			  text-transform:uppercase;
			  transition:0.5s;
			}
			
			nav ul:hover li a{
			  transform:scale(1.05);
			  opacity:0.2;
			}
			
			nav ul li a:hover{
			  transform:scale(1.05);
			  opacity:1;			  
			  text-decoration:none;
			  color:#fff;
			}
			
			nav ul li a:before{
			  content:'';
			  position:absolute;
			  top:;
			  left:0;
			  width:100%;
			  height:30%;
			  background:#ff497c;
			  transition:0.5s;
			  transform-origin:right;
			  transform:scaleX(0);
			  z-index:-1;
			}			
			nav ul li a:hover:before{
			  transition:transform 0.5s;
			  transform-origin:left;
			  transform:scaleX(1);
			}
		</style>
	</body>
</html>
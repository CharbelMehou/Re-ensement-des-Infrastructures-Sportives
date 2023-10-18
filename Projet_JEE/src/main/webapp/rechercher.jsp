<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="dao.DBDAO"%>
<%@ page import="dao.CSVReader"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <!-- Liens pour Bootstrap -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
  <title>Recensement des infrastructures sportives</title>
</head>
<body>
<% 			
			Connection conn = null;
	   		Statement stmt = null;
	   		ResultSet rs_retrieve_all = null;
	   		ResultSet rs_max_page = null;
	   		String categorie = request.getParameter("categorie");
	   		String codepostal = request.getParameter("codepostal");
	   		String currentPage = request.getParameter("page");
	   		
				
	       
	       try {
	           conn = DBDAO.dbConnect();
	           stmt = conn.createStatement();
	           
           
%>
  <h1>Infrastructures sportives</h1>
  <div class="container">
    <!-- Formulaire de recherche -->
    <form action="rechercher.jsp" method="get">
      <div class="form-row">
        <div class="col-md-6 mb-3">
          <label for="categorie">Catégorie</label>
          <select class="custom-select" name="categorie" id="categorie" data-live-search="true">
          		<option value="">Toutes les catégories</option>
          	<% 
          		List<String[]> lines = CSVReader.readCSV("..\\..\\ressources\\2020_activite_pour_categ_ok.csv");
          		for (String[] line : lines) {
          	%>
      			<option value="<%=line[0]%>"><%= line[0]%></option>
          	<%		
          		}
          	%>
            
        	
          </select>
          <script>
			  $(document).ready(function() {
			    $('#categorie').select2();
			  });
		  </script>
        </div>
        <div class="col-md-6 mb-3">
          <label for="codepostal">Code postal</label>
          <input type="text" class="form-control" id="codepostal" name="codepostal">
        </div>
      </div>
      <input type="hidden" id="page" name="page" value="0">
      <button class="btn btn-primary" type="submit">Rechercher</button>
    </form>
    
    <!-- Tableau des infrastructures sportives -->
    <table class="table">
      <thead>
        <tr>
          <th>Nom</th>
          <th>Sport</th>
          <th>Localisation</th>
        </tr>
      </thead>
      <tbody>
      
       <%
      			 int itemsPerPage = 20;
        		 int offset = Integer.valueOf(currentPage)*itemsPerPage;
        		 int choice;
        		 String query_retrieve_all = "";
        		 String query_MaxPage = "";
        		 String echap = "\\";
       					
       				//In the case of a search by postal code
       				if(categorie.equals("") && codepostal != "") {
	       				
	    	   			 query_MaxPage = "SELECT COUNT(*) FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE p.postalcode_col = " +codepostal;
	       				 rs_max_page = stmt.executeQuery(query_MaxPage);
	    	   			
	    	   			 //query_retrieve_all = "SELECT e.InsNom, e.EquipementId, e.DepCode, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId WHERE e.DepCode = " +codepostal + " LIMIT " +itemsPerPage +" OFFSET "+offset;
	    	   			 query_retrieve_all = "SELECT e.InsNom, e.EquipementId, p.postalcode_col, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE p.postalcode_col = " +codepostal +" LIMIT " +itemsPerPage +" OFFSET " +offset;
        		 	     System.out.println(query_retrieve_all);
       				}
       			   //In the case of a search by category
       				if(categorie != "" && codepostal.equals("")) {
       					if(categorie.equals("Tir à l'arc")) {
	    	   				query_MaxPage = "SELECT COUNT(*) FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId WHERE a.ActDiscipline LIKE '%Tir à l"+echap+"'arc%'";
	    	   				
	    	   				query_retrieve_all = "SELECT e.InsNom, e.EquipementId, p.postalcode_col, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%Tir à l"+echap+"'arc%' LIMIT " +itemsPerPage +" OFFSET "+offset;
	    	   			 
       					 }else {
       					
	       					query_MaxPage = "SELECT COUNT(*) FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId WHERE a.ActDiscipline LIKE '%" +categorie +"%'";
		    	   			
		    	   			 
		    	   			query_retrieve_all = "SELECT e.InsNom, e.EquipementId, p.postalcode_col, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%" +categorie + "%' LIMIT " +itemsPerPage +" OFFSET "+offset;
       					}
       				
       					rs_max_page = stmt.executeQuery(query_MaxPage);
       				}
       			    //In the case of a search by category && postalcode
       			    if(categorie != "" && codepostal != "") {
       			    	if(categorie.equals("Tir à l'arc")) {
       					
	    	   				query_MaxPage = "SELECT COUNT(*) FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%Tir à l"+echap+"'arc%' AND p.postalcode_col = " +codepostal;

	    	   				query_retrieve_all = "SELECT e.InsNom, e.EquipementId, p.postalcode_col, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%Tir à l"+echap+"'arc%' AND p.postalcode_col = " +codepostal +" LIMIT " +itemsPerPage +" OFFSET "+offset;
	    	   			 
       					 }else {
       			    	
       			    	query_MaxPage = "SELECT COUNT(*) FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%" +categorie + "%' AND p.postalcode_col = " +codepostal;
	    	   			
       			
	    	   			 query_retrieve_all = "SELECT e.InsNom, e.EquipementId, p.postalcode_col, e.ComLib, a.EquipementId, a.ActDiscipline FROM equipement e LEFT JOIN activite a ON e.EquipementId = a.EquipementId LEFT JOIN postalcode p ON e.ComInsee = p.code_insee WHERE a.ActDiscipline LIKE '%" +categorie + "%' AND p.postalcode_col = " +codepostal +" LIMIT " +itemsPerPage +" OFFSET "+offset;
       					 }
       			     	rs_max_page = stmt.executeQuery(query_MaxPage);
       			    }
       			    //In the case of a search by nothing
       			    if(categorie.equals("") && codepostal.equals("")) { 
       			    	response.sendRedirect("index.jsp?page=0");	
       			    }
       			
        	   
        	   int nbElementBdd = 0;
	           if(rs_max_page.next())
	        	   nbElementBdd = rs_max_page.getInt(1);
	 
	           int maxPage = nbElementBdd/itemsPerPage;

	           rs_retrieve_all = stmt.executeQuery(query_retrieve_all);
	         
	           while(rs_retrieve_all.next()) {
 
	        %>
        <tr>
          <td><a href="details.jsp?id=<%= rs_retrieve_all.getString("e.EquipementId") %>"><%= rs_retrieve_all.getString("InsNom") %></a></td>
          <td><% if(rs_retrieve_all.getString("e.EquipementId").equals(rs_retrieve_all.getString("a.EquipementId"))) { %>
      			  <%= rs_retrieve_all.getString("a.ActDiscipline") %><%}else { %>Non spécifié<%} %>
		  </td>
          <td><%= rs_retrieve_all.getString("ComLib") %> (<%=rs_retrieve_all.getString("postalcode_col")%>)</td>
        </tr>
        <tr>
        <%	
	        	  }	
		 %>
      </tbody>
    </table>
  </div>
  
  <nav>
  		<ul class="pagination">
  			<li class="page-item"><a class="page-link" href="rechercher.jsp?page=<%=0%>&codepostal=<%=codepostal%>&categorie=<%=categorie%>">0 ..</a></li>
  			<% if(Integer.parseInt(currentPage)!=0) {%>
    		<li class="page-item"><a class="page-link" href="rechercher.jsp?page=<%=Integer.valueOf(currentPage)-1%>&codepostal=<%=codepostal%>&categorie=<%=categorie%>">Précédent</a></li>
    		<%
  			}else { %>
  				<li class="page-item"><a disabled style="pointer-events: none" class="page-link">Précédent</a></li>
  			<%
  			}
    		ArrayList<Integer> tab = new ArrayList<Integer>();
    		for (int j=0;j<maxPage;j++) {
    			tab.add(j);
    		}
    		int numPages = maxPage + 1;
    		int startPage = Math.max(0, Integer.parseInt(currentPage) - 3);
    		int endPage = Math.min(numPages, startPage + 8);
    		for (int i = startPage; i < endPage; i++) {
		    	%>
		    	<li class="page-item <%=(i==Integer.parseInt(currentPage))?"active":""%>"><a class="page-link" href="rechercher.jsp?page=<%=i%>&codepostal=<%=codepostal%>&categorie=<%=categorie%>"><%=i%></a></li>
		    	<%
		    	}
    		if(Integer.parseInt(currentPage)!=maxPage) {
		    	%>
    		<li class="page-item"><a class="page-link" href="rechercher.jsp?page=<%=Integer.valueOf(currentPage)+1%>&codepostal=<%=codepostal%>&categorie=<%=categorie%>">Suivant</a></li>
    		<%}else{ %>
    		<li class="page-item"><a disabled style="pointer-events: none" class="page-link">Suivant</a></li>
    		<%} %>
    		<li class="page-item"><a class="page-link" href="rechercher.jsp?page=<%=maxPage%>&codepostal=<%=codepostal%>&categorie=<%=categorie%>">..<%=maxPage%></a></li>
  		</ul>
	</nav>
	<%
 		}catch(Exception e) {
			System.out.println("Bug lors de la recuperation des données");
	
	 	}finally {
	    // Fermeture de la connexion et des ressources
	    		try {
				      if (rs_retrieve_all != null) rs_retrieve_all.close();
				      if (stmt != null) stmt.close();
				      if (conn != null) conn.close();
	    	} catch (SQLException ex) {
	     		 ex.printStackTrace();
	    	}
	  }
	%>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="dao.DBDAO"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.Infodao" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <!-- Liens pour Bootstrap -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
  <link rel="stylesheet" href="/Projet_JEE/src/main/css/project.css"> 
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
  
  	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
     integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
     crossorigin=""/>	
     <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
     integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
     crossorigin=""></script>
   
  <title>Détails de l'infrastructure</title>
</head>
<body>
  <div class="container"'>
    <h1>Détails de l'infrastructure</h1>
    <table class="table">
      <tbody>
        <%
        Infodao dao = new Infodao();
        Connection conn = null;
	    Statement stmt = null;
	    ResultSet rs = null;
        
	    try{
        	
	    	conn = DBDAO.dbConnect();
	    	// Récupération de l'EquipementId depuis la requête HTTP
	    	String EquipementId = request.getParameter("id");
	    
		
		    // Requête SQL pour récupérer les détails de l'infrastructure
		    String query = "SELECT equipement.DepCode, equipement.ComInsee, equipement.ComLib, equipement.InsNom, equipement.EquNom, equipement.EquipementTypeLib, equipement.EquipementCateg, equipement.DepLib, equipement.EquGPSX, equipement.EquGPSY,equipement.EquDateMaj, activite.ActDiscipline FROM equipement LEFT JOIN activite ON equipement.EquipementId = activite.EquipementId WHERE equipement.EquipementId = '" + EquipementId + "'";
		    
		    // Exécution de la requête SQL
		    stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
        	
      
	            
		    while (rs.next()) {	         
        %>
        
        <tr>
          <td><strong>Commune</strong></td>
          <td><%= rs.getString("ComLib") %></td>
        </tr>
        <tr>
          <td><strong>Département</strong></td>
          <td><%= rs.getString("DepLib") %> (<%=  rs.getString("DepCode")%>)</td>
        </tr>
        <tr>
          <td><strong>Code INSEE</strong></td>
          <td><%= rs.getString("ComInsee") %></td>
        </tr>
        <tr>
          <td><strong>Nom de l'infrastructure</strong></td>
          <td><%= rs.getString("InsNom") %></td>
        </tr>
        <tr>
          <td><strong>Nom de l'équipement</strong></td>
          <td><%= rs.getString("EquNom") %></td>
        </tr>
        <tr>
          <td><strong>Type d'équipement</strong></td>
          <td><%= rs.getString("EquipementTypeLib") %></td>
        </tr>
        <tr>
        <td><strong>Catégorie de l'équipement</strong></td>
          <td><%= rs.getString("EquipementCateg") %></td>
        </tr>
        <tr>
        <td><strong>Sport(s) praticable(s)</strong></td>
          <td><% if(rs.getString("ActDiscipline")!= null) { %>
          			<%= rs.getString("ActDiscipline") %>
          	  <%}else{%>Non Spécifié<%} %>
          </td>
        </tr>
        <tr>
        <td><strong>Date de mise à jour de la fiche</strong></td>
          <td><%if(rs.getString("EquDateMaj") != null) { %>
        	  	<%= rs.getString("EquDateMaj") %>
        	  <%}else {%>Non Spécifié<%} %></td>
        </tr>
        <%   
		     String inseeEquipement=rs.getString("ComInsee");
			 Infodao infodao=new Infodao();
			 infodao.setAllInfo(inseeEquipement);
    	%>
         <tr>
        <td><strong>Nom de la mairie associée</strong></td>
          <td><%if(infodao.getNomMairie() != null) { %>
          			<%= infodao.getNomMairie() %>
          	   <%}else{%>Non spécifié<%} %>
          	   </td>
        </tr>
        <tr>
        <td><strong>Editeur</strong></td>
          <td><%if(infodao.getEditeur() != null) {%>
          			<%= infodao.getEditeur() %>
          	  <%}else { %>Non spécifié<%}%>
          </td>
        </tr>
        <tr>
        <td><strong>Adresse de la mairie</strong></td>
          <td><%if(infodao.getAdresseMairie() != null) { %>
        	  		<%= infodao.getAdresseMairie() %>  		
          <%}else { %>Non spécifié <%} %>
          </td>
        </tr>
        <tr>
        <td><strong>Coordonnées de la mairie</strong></td>
          <td><%if(infodao.getCoordonnéesNum() != null) {%>
          			<%= infodao.getCoordonnéesNum() %>
          	<%}else { %>Non spécifié<%} %>
          </td>
        </tr>
        <tr>
        <td><strong>Jours d'ouverture de la mairie</strong></td>
         <td><%if(infodao.getOpenhours() != "") {%>
         			<%= infodao.getOpenhours() %>
         	<%}else { %>Non spécifié <%} %>
         </td>
    	</tr>
        <tr>
        <td><strong>Site web de la mairie</strong></td>
          <td><%if(infodao.getUrl() != null) {%><a href="<%= infodao.getUrl() %>" ><%= infodao.getUrl() %></a><%}else { %>Non spécifié<%} %></td>
        </tr>
       </tbody>
    </table>

     <!--  Affichage de la mairie liée à l'infrastructure sur la map-->
    	<div class="row d-flex justify-content-center" >
				<div class=" col-8  " id="map" style="height: 600px">
						<script>
								  // Création d' une carte Leaflet centrée sur la marie qui régit l'infrastructure
								  var map = L.map('map').setView([<%=infodao.getLatitude()%>, <%=infodao.getLongitude()%>], 13);
								
								  // Ajout d'une tuile OpenStreetMap à la carte
								  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
								    attribution: '© OpenStreetMap contributors'
								}).addTo(map);
								  
								  //On creer le marker  
									 var mairieMarker = L.marker([<%=infodao.getLatitude()%>,<%=infodao.getLongitude()%>],{autoOpenPopup: true}).addTo(map);  
									    
								  mairieMarker.setIcon(L.icon({
									    iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
									    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
									    iconSize: [25, 41],
									    iconAnchor: [12, 41]
									  }));	  
								  mairieMarker.bindPopup("<%=infodao.getNomMairie()%>"  + "<br>" + "Longitude : " + <%=infodao.getLongitude()%> + "<br>" + "Latitude : " + <%=infodao.getLatitude()%>);	 
								  mairieMarker.addTo(map);
								
								  //Le marker de l'infrastructure
							
									 var infrMarker = L.marker([<%= rs.getString("EquGPSY")%>,<%=rs.getString("EquGPSX")%>],{autoOpenPopup: true}).addTo(map);   	
								     //l'ecouteur d'évenement au clic 
								     infrMarker.bindPopup("<%=rs.getString("InsNom")%>" + "<br>" + "Longitude : " + <%=rs.getString("EquGPSX")%> + "<br>" + "Latitude : " + <%=rs.getString("EquGPSY")%>);	 
                                     infrMarker.addTo(map);														  
					   </script>
				</div>
		</div>
     <% 
  }
    	 }catch(Exception e) {
		 	System.out.println("Bug lors de la recuperation des données");
		 }finally {
	     // Fermeture de la connexion et des ressources
	   	 try {
		 	if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
	   	}catch (SQLException ex) {
	    		 ex.printStackTrace();
	   	}
	 } 	
 %>		
  </div>
 </body>
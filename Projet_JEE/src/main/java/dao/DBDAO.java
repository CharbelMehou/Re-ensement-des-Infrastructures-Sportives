package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBDAO {
	  // nom de la machine hôte qui héberge le SGBD Mysql
    final static String host = "localhost";
    // nom de la BDD sur le serveur Mysql
    final static String nomBase = "bdd_projet_jee";
    // login de la BDD
    final static String login = "root";
    // mot de passe
    final static String motDePasse = "root";
    
	public static Connection dbConnect() throws ClassNotFoundException, SQLException {
	  
	    
	    Connection con = null;         //objet connexion
	    
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	    } catch (ClassNotFoundException e2) {
	        System.err.println("pilote mysql non trouvé : com.mysql.cj.jdbc.Driver");
	        System.exit(-1);
	    }
	    
	    try {
	        // Connexion avec choix de l'encodage
	        con = DriverManager.getConnection("jdbc:mysql://" + host + "/" + nomBase + "?characterEncoding=UTF-8",
	                login, motDePasse);
	    } catch(SQLException e) {
	        System.out.println("Erreur lors de la connexion a la bdd");
	        e.printStackTrace();
	    }
	    
	    return con;
	}
}


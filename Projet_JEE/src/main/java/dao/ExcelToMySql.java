package dao;

/**
 * Fichier permettant d'importer un fichier CSV dans une table MySQL
 * Ce Script utilise le mode transactionnel afin de respecter l'approche ACID (Atomicité, Cohérence, Isolation, Durabilité) 
 * qui permet d'assurer l'intégrité des données au sein d'une base de données. 
 * @author Serais Sébastien
 */
import java.sql.*;
import java.util.List;

public class ExcelToMySql {
	// nom de la machine hôte qui héberge le SGBD Mysql
	final static String host = "localhost";
	// nom de la BDD sur le serveur Mysql
	final static String nomBase = "bdd_projet_jee";
	// login de la BDD
	final static String login = "root";
	// mot de passe
	final static String motDePasse = "root";
	// caractère de séparation des colonne
	final static String separateur = ";";
	final static String nomTable = "equipement";

	public static void main(String[] args) {
		Connection con = null;			//objet connexion
		PreparedStatement stmt = null;	//prepareStatement	
	
		
				// chargement du pilote MySQL
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
		
		List<String[]> lines = CSVReader.readCSV("D:\\Projet Java\\2020_Equipements_csv_ok.csv");
		int i =0;
			for (String[] line : lines) {
				 
	        	String requete_equipement = "insert into " + nomTable + "(EquipementId,DepCode,ComInsee,ComLib,InsNom,EquNom,EquipementTypeLib,EquipementCateg,DepLib,EquGPSX,EquGPSY) values (?,?,?,?,?,?,?,?,?,?,?)";
				stmt = con.prepareStatement(requete_equipement);
			
				stmt.setString(1, line[6]);//EquipementId
				stmt.setString(2, line[0]);//DepCode
	        	stmt.setString(3, line[2]);//ComInsee
	        	stmt.setString(4, line[3]);//ComLib
	        	stmt.setString(5, line[5]);//InsNom
	        	stmt.setString(6, line[7]);//EquNom
	        	stmt.setString(7, line[10]);//EquipementTypeLib
	        	stmt.setString(8, line[12]);//EquipementCateg
	        	stmt.setString(9, line[1]);//DepLib
				stmt.setString(10, line[191]);//EquGPSX
				stmt.setString(11, line[192]);//EquGPSY
				stmt.executeUpdate();
				i++;
				System.out.println(i);
				
			 }
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
}
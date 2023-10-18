/**
 * @author mehou&ferry
 */
package dao;

import java.io.File;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class Infodao {
	
	private String nomMairie;
	private String editeur;
	private String adresseMairie;
	private String longitude;
	private String latitude;
	private String CoordonnéesNum;
	private String openhours = "";
	private String url;
	
	public Infodao(){
	
	}
	
	/**
	 * This method allow to set all the info related to a "mairies"
	 * 
	 */
	
	public void setAllInfo (String  inseeEquipement) {
		//String inseeEquipement = "2A041"; // Remplacez par le numéro Insee de votre équipement
        File dossierXML = new File("C:\\Users\\mehou\\Downloads\\mairies\\cleanDatas"); // Remplacez par le chemin vers votre dossier XML

        if (dossierXML.isDirectory()) { // Vérifiez si le chemin pointe vers un dossier
            
        	File[] fichiersXML = dossierXML.listFiles(); //Obtenez tous les fichiers dans le dossier

            for (File fichierXML : fichiersXML) { 
            	// Parcourez tous les fichiers dans le dossier
                if (fichierXML.getName().startsWith(inseeEquipement) && fichierXML.getName().endsWith(".xml")) {
                    
                	// Vérifiez si le nom du fichier correspond au numéro Insee et a l'extension XML
                    System.out.println("Le fichier XML correspondant à l'équipement sportif est : " + fichierXML.getName());

                    // Ouvrez et lisez le fichier XML
                   
                    try {
                    	
                        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                        DocumentBuilder builder = factory.newDocumentBuilder();
                        Document document = builder.parse(fichierXML);

                        // Extrait les informations de nom et d'adresse de la mairie
                        Element organisme = (Element) document.getElementsByTagName("Organisme").item(0);
                        
                        this.nomMairie = organisme.getElementsByTagName("Nom").item(0).getTextContent();
                        
                        this.editeur = organisme.getElementsByTagName("EditeurSource").item(0).getTextContent();
                       
                        this.adresseMairie = organisme.getElementsByTagName("Ligne").item(0).getTextContent() + ", " +
                                         organisme.getElementsByTagName("CodePostal").item(0).getTextContent() + " " +
                                         organisme.getElementsByTagName("NomCommune").item(0).getTextContent();
                        
                        
                        this.longitude=organisme.getElementsByTagName("Longitude").item(0).getTextContent();
                        
                        this.latitude=organisme.getElementsByTagName("Latitude").item(0).getTextContent();
                        
                        //Case : PHONE
                        if(organisme.getElementsByTagName("Téléphone") != null && organisme.getElementsByTagName("Télécopie").item(0) == null && organisme.getElementsByTagName("Email").item(0)== null) {
                        	this.CoordonnéesNum =	"Téléphone : " +organisme.getElementsByTagName("Téléphone").item(0).getTextContent();
                        }
                        //Case : PHONE + TELECOPIE
                        else if(organisme.getElementsByTagName("Téléphone") != null && organisme.getElementsByTagName("Télécopie").item(0) != null && organisme.getElementsByTagName("Email").item(0) == null) {
                        	System.out.println("test");
                        	this.CoordonnéesNum =	"Téléphone : " +organisme.getElementsByTagName("Téléphone").item(0).getTextContent() + ", Télécopie : " +
    												organisme.getElementsByTagName("Télécopie").item(0).getTextContent();
                        	
                        }
                        //Case : TELECOPIE
                        else if(organisme.getElementsByTagName("Téléphone") == null && organisme.getElementsByTagName("Télécopie").item(0) != null && organisme.getElementsByTagName("Email").item(0) == null) {
                        	this.CoordonnéesNum =	"Télécopie : " + organisme.getElementsByTagName("Télécopie").item(0).getTextContent();
                        }
                        //Case : EMAIL
                        else if(organisme.getElementsByTagName("Téléphone") == null && organisme.getElementsByTagName("Télécopie").item(0) == null && organisme.getElementsByTagName("Email").item(0) != null) {
                        	this.CoordonnéesNum =	"Email : " +organisme.getElementsByTagName("Email").item(0).getTextContent();
                        }
                        //Case : TELECOPIE + EMAIL
                        else if(organisme.getElementsByTagName("Téléphone") == null && organisme.getElementsByTagName("Télécopie").item(0) != null && organisme.getElementsByTagName("Email").item(0) != null) {
                        	this.CoordonnéesNum =	"Télécopie : " +
    								organisme.getElementsByTagName("Télécopie").item(0).getTextContent()+ ", Email : " +
    								organisme.getElementsByTagName("Email").item(0).getTextContent();
                        }
                        //Case : PHONE + EMAIL
                        else if(organisme.getElementsByTagName("Téléphone") != null && organisme.getElementsByTagName("Télécopie").item(0) == null && organisme.getElementsByTagName("Email").item(0) != null) {
                        	this.CoordonnéesNum =	"Téléphone : " +
    								organisme.getElementsByTagName("Téléphone").item(0).getTextContent() + ", Email : " +
    								organisme.getElementsByTagName("Email").item(0).getTextContent();
                        }
                        //Case : PHONE + TELECOPIE + EMAIL 
                        else if(organisme.getElementsByTagName("Téléphone").item(0) !=null && organisme.getElementsByTagName("Télécopie").item(0)!=null && organisme.getElementsByTagName("Email").item(0)!=null) {
                        	this.CoordonnéesNum =	"Téléphone : " +organisme.getElementsByTagName("Téléphone").item(0).getTextContent() + ", Télécopie : " +
                								organisme.getElementsByTagName("Télécopie").item(0).getTextContent()+ ", Email : " +
                								organisme.getElementsByTagName("Email").item(0).getTextContent();
                        }
                        //Case : nothing
                        else if(organisme.getElementsByTagName("Téléphone") == null && organisme.getElementsByTagName("Télécopie").item(0) == null && organisme.getElementsByTagName("Email").item(0) == null) {
                        	this.CoordonnéesNum = "Non spécifié";
                        }
                       
                        if(organisme.getElementsByTagName("Url").item(0) !=null) {
                        	this.url = organisme.getElementsByTagName("Url").item(0).getTextContent();
                        }
                        
                      
                        NodeList plageJList = document.getElementsByTagName("PlageJ");
                        for (int i = 0; i < plageJList.getLength(); i++) {
                            Node plageJNode = plageJList.item(i);
                            if (plageJNode.getNodeType() == Node.ELEMENT_NODE) {
                                Element plageJElement = (Element) plageJNode;
                                String plageJDebut = plageJElement.getAttribute("début");
                                String plageJFin = plageJElement.getAttribute("fin");
                                NodeList plageHList = plageJElement.getElementsByTagName("PlageH");
                                StringBuilder plageHs = new StringBuilder();
                                for (int j = 0; j < plageHList.getLength(); j++) {
                                    Element plageHElement = (Element) plageHList.item(j);
                                    String plageHDebut = plageHElement.getAttribute("début");
                                    String plageHFin = plageHElement.getAttribute("fin");
                                    String plageH = plageHDebut + " - " + plageHFin;
                                    plageHs.append(plageH).append(" / ");
                                }
                                String plageHsString = plageHs.toString().replaceAll(" / $", "");
                                
                                if(plageJDebut.equals(plageJFin)) {
                                	this.openhours += "Le " + plageJDebut  + " : " + plageHsString+" <br> ";
                                	
                                	
                                }else {
                                	this.openhours += "Du " + plageJDebut + " au " + plageJFin + " : " + plageHsString+" <br> ";
                                	
                                }
                            }
                        }                       
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
             }
         }else {
        	 System.out.println("Wrong path,there's no XML file");
         }
	}
	

	public String getNomMairie() {
		return nomMairie;
	}

	public String getEditeur() {
		return editeur;
	}

	public String getAdresseMairie() {
		return adresseMairie;
	}

	public String getLongitude() {
		return longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public String getCoordonnéesNum() {
		return CoordonnéesNum;
	}

	public String getOpenhours() {
		return openhours;
	}

	public String getUrl() {
		return url;
	}
	



}

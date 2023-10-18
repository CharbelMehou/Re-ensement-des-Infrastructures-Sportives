package dao;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;

public class EquipementSportif {

    public static void main(String[] args) {
        String inseeEquipement = "01001"; // Remplacez par le numéro Insee de votre équipement
        File dossierXML = new File("D:\\Projet Java\\cleanDatas"); // Remplacez par le chemin vers votre dossier XML

        if (dossierXML.isDirectory()) { // Vérifiez si le chemin pointe vers un dossier
            File[] fichiersXML = dossierXML.listFiles(); // Obtenez tous les fichiers dans le dossier

            for (File fichierXML : fichiersXML) { // Parcourez tous les fichiers dans le dossier
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
                        String nom = organisme.getElementsByTagName("Nom").item(0).getTextContent();
                        String editeur = organisme.getElementsByTagName("EditeurSource").item(0).getTextContent();
                        String adresse = organisme.getElementsByTagName("Ligne").item(0).getTextContent() + ", " +
                                         organisme.getElementsByTagName("CodePostal").item(0).getTextContent() + " " +
                                         organisme.getElementsByTagName("NomCommune").item(0).getTextContent();
                        String localisation =	"Latitude : " +organisme.getElementsByTagName("Latitude").item(0).getTextContent() + ", Longitude : " +
                                				organisme.getElementsByTagName("Longitude").item(0).getTextContent() + ", Précision : " +
                                				organisme.getElementsByTagName("Précision").item(0).getTextContent();
                        String CoordonnéesNum =	"Téléphone : " +organisme.getElementsByTagName("Téléphone").item(0).getTextContent() + ", Télécopie : " +
                								organisme.getElementsByTagName("Télécopie").item(0).getTextContent();
                        NodeList plageJList = document.getElementsByTagName("PlageJ");
                        Element plageJ = (Element) plageJList.item(0);
                        String debutJ = plageJ.getAttribute("début");
                        String finJ = plageJ.getAttribute("fin");
                        NodeList plageHList = document.getElementsByTagName("PlageH");
                        Element plageH = (Element) plageHList.item(0);
                        String debutH = plageH.getAttribute("début");
                        String finH = plageH.getAttribute("fin");
                        // Affichez les informations extraites dans la console
                        System.out.println("Nom de la mairie : " + nom);
                        System.out.println("Source de l'éditeur : " + editeur);
                        System.out.println("Adresse de la mairie : " + adresse);
                        System.out.println("Coordonnées : " + CoordonnéesNum);
                        System.out.println("Localisation : " + localisation);
                        System.out.println("Jours d'ouverture : " + debutJ + " à " +finJ);
                        System.out.println("Heures d'ouverture : " + debutH + " à " +finH);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
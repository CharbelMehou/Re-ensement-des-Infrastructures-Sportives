package dao;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
* The CSVReader class provides a static method to read data from a CSV file.
* 
* @author FERRY Axel RICQUE Clément
* @version 1.0 21/02/2023
*/
public class CSVReader {
    private static final String COMMA_DELIMITER = ";";
    
    /**
    * Reads data from a CSV file and returns a list of string arrays, where each
    * string array represents a line in the file.
    *
    * @param fileName : the name of the CSV file to read from
    * @return a list of string arrays representing the lines in the file
    */
    public static List<String[]> readCSV(String fileName) {
    	
        BufferedReader br = null;
        List<String[]> lines = new ArrayList<String[]>();
        
        //try to read the document, if there is an error, print the error and finally close the excel document
        try {
        	//The BufferedReader instantiation which allow to read in the excel document
            br = new BufferedReader(new FileReader(fileName));
            br.readLine();
            String line;
            
            //Add each excel line in the array, using the method split to split with the special parameter "COMA_DELIMITER" 
            //to split the excel line after any coma to have the good date format.
            while ((line = br.readLine()) != null) {
                lines.add(line.split(COMMA_DELIMITER));
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return lines;
    }
}
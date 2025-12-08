import java.io.File;
import java.io.FileNotFoundException;

import java.util.Scanner;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
      try {
            File file = new File("/uploads/input4.txt");
            Scanner scanner = new Scanner(file);
            
            ArrayList<String> lines = new ArrayList<>();
            while (scanner.hasNextLine()) {
                lines.add(scanner.nextLine());
            }
            
            scanner.close();
            
            char[][] diagram = new char[lines.size()][];
            
            for (int i = 0; i < lines.size(); i++) {
                diagram[i] = lines.get(i).toCharArray();
                
            }
            
            System.out.println("\nEntire grid:");
            for (int i = 0; i < diagram.length; i++) {
                for (int j = 0; j < diagram[i].length; j++) {
                    System.out.print(diagram[i][j]);
                }
                System.out.println();
            }
            
            int is_accessible = 0;
            
            for(int i = 0; i < diagram.length; i++) {
                for(int j = 0; j < diagram[i].length; j++) {
                    
                    if(diagram[i][j] == '@') {
                        int neighbours = 0;
                        
                        for (int nr = i - 1; nr <= i + 1; nr++) {
                            for (int nc = j - 1; nc <= j + 1; nc++){
                                // System.out.println("Checking cell [" + nr + "][" + nc + "]");                                

                                // Skip myself
                                if(nr == i && nc == j) {
                                    continue;
                                }
                                
                                if( nr >= 0 && nc >= 0 && nr < diagram.length && nc < diagram[i].length){
                                    if(diagram[nr][nc] == '@') {
                                        neighbours++;
                                    
                                    } 
                                }
                            }
                        }

                        
                        if(neighbours < 4) {
                            is_accessible++;
                        }
                        
                    } else {
                        continue;
                    }
                    
                }
            }
            
            System.out.println(is_accessible);
            
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        }
    
  }
}

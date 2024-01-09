# #!/bin/bash
 
# DIRECTORY=''  
# # Replace with your directory path
 
# for FILE in "$DIRECTORY"/*.json; do    
 
# # Check if 'project.apis' exists and is an array    
#     if jq 'if .project.apis and (.project.apis | type == "array") then true else false end' "$FILE" > /dev/null; then        
 
# # Check if the specific API is not in the array        
#         if ! jq '.project.apis | contains(["policyanalyzer.googleapis.com"])' "$FILE" > /dev/null; then            
#             echo "Adding API to $FILE"            
#             jq '.project.apis += ["policyanalyzer.googleapis.com"]' "$FILE" > tmp.json && mv tmp.json "$FILE"        
#         else
#             echo "API already exists in $FILE"        
#         fi    
#     else        
#         echo "'apis' field not found or not an array in $FILE"    
#     fi
# done
 
 
#!/bin/bash
 
#This script is adding an item to the end of the list in json files
#Modify DIRECTORY, list name(in our case - 'project.apis'), and item to be added(in our case - "policyanalyzer.googleapis.com") 
DIRECTORY=''  
for FILE in "$DIRECTORY"/*.json; do
    # Check if 'project.apis' contains 'policyanalyzer.googleapis.com'
    if jq '.project.apis | if type == "array" then contains(["policyanalyzer.googleapis.com"]) else false end' "$FILE" | grep -q false; then
        echo "Adding API to $FILE"
        jq '.project.apis |= if type == "array" then . + ["policyanalyzer.googleapis.com"] else ["policyanalyzer.googleapis.com"] end' "$FILE" > tmp.json && mv tmp.json "$FILE"
    else
        echo "API already exists in $FILE"
    fi
done

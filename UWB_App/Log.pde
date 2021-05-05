Table table;
boolean logging = false;
int exportedCount = 0;
void setUpLog(){
     table = new Table();
     table.addColumn("id");
     table.addColumn("A");
     table.addColumn("B");
     table.addColumn("C");
     exportedCount = 0;
}

void startLogging(){
    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount() - 1);
    newRow.setFloat("A", d1);
    newRow.setFloat("B", d2);
    newRow.setFloat("C", d3);
    exportedCount++;
}
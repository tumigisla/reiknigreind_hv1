import openpyxl
import xlrd
import os
import csv

for file in os.listdir('.'):
    if file.endswith('.xls') or file.endswith('.xlsx'):
        wb = xlrd.open_workbook(file)
        for i in range(len(wb.sheet_names())):
            sh = wb.sheet_by_index(i)
            with open(file.split('.')[0] + str(i) + '.csv', 'w') as f:
                c = csv.writer(f)
                for r in range(sh.nrows):
                    c.writerow(sh.row_values(r))
    else:
        continue


#wb = openpyxl.load_workbook('.xlsx')
#sh = wb.get_active_sheet()
#with open('test.csv', 'wb') as f:
#    c = csv.writer(f)
#    for r in sh.rows:
#        c.writerow([cell.value for cell in r])
Sub SendCustomers()
    SendEmail ("guy.guzman@gmail.com")
End Sub

Sub SendEmail(EmailAddress As String)
     
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Dim fs, f
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.OpenTextFile("C:\Users\guygu\OneDrive\Rainier\Email HTML Templates\fuelprices.html", ForReading)
    TextString = f.ReadAll
    f.Close
    
    Dim OutlookApp  As Outlook.Application
    Dim OutlookMail As Outlook.MailItem
    
    Set OutlookApp = New Outlook.Application
    
    For Each oAccount In OutlookApp.Session.Accounts
        If oAccount.DisplayName = "support@easydmr.com" Then
        Debug.Print oAccount.DisplayName
            Set OutlookMail = OutlookApp.CreateItem(olMailItem)
            With OutlookMail
                .BodyFormat = olFormatHTML
                .HTMLBody = TextString
                .SendUsingAccount = oAccount
                '.Display
                .To = EmailAddress
                '.CC = "sales@easydmr.com"
                '.BCC = "support@easydmr.com"
                .Subject = "Weekly Fuel Price Update"
                .Send
            End With
        End If
    Next
End Sub

Sub SendExcelPromo()
    
    Debug.Print "-------------------------------"
    
    Dim ExcelFile   As String
    Dim ExcelApp    As Excel.Application
    Dim Workbook         As Excel.Workbook
    Dim WorkSheet        As Excel.WorkSheet
    Dim EntireRange  As Excel.Range
    Dim Cell        As Range
    Dim Row As Range
    Dim ValidEmailAddress As Boolean
    Dim FirstSent As Boolean
        Dim SecondSent As Boolean
    Dim Today As Date
    Dim EmailAddress As String
    Dim Counter As Integer
    
    ValidEmail = False
    
    ExcelFile = "C:\Users\guygu\OneDrive\Rainier\Email HTML Templates\jimmyjohns.xlsx"
    
    Set ExcelApp = CreateObject("Excel.Application")
    Set Workbook = ExcelApp.Workbooks.Open(ExcelFile)
    Set WorkSheet = Workbook.Sheets(1)
    WorkSheet.Activate
    Set EntireRange = WorkSheet.Range("A1:A10")
    EntireRange.Activate
    ExcelApp.Visible = False
    
    For Each Cell In WorkSheet.Range("A2:A4")
        'Debug.Print Cell.Value
    Next Cell
    
    Today = Now
    Counter = 0
    
    For RowNumber = 2 To 875
     'Debug.Print WorkSheet.Cells(RowNumber, 11) & " - "; WorkSheet.Cells(RowNumber, 12) & " - " & WorkSheet.Cells(RowNumber, 9)
     ValidEmailAddress = False
     FirstSent = False
     SecondSent = False
     EmailAddress = WorkSheet.Cells(RowNumber, 9)
     If WorkSheet.Cells(RowNumber, 11) <> "False" Then ValidEmailAddress = True
     If WorkSheet.Cells(RowNumber, 12) <> "" Then FirstSent = True
     If WorkSheet.Cells(RowNumber, 13) <> "" Then SecondSent = True
     If ValidEmailAddress = True And FirstSent = True And SecondSent = False Then
        Counter = Counter + 1
        Debug.Print (EmailAddress)
        If Counter < 6 Then
            SendEmail (EmailAddress)
            WorkSheet.Cells(RowNumber, 13) = Now
            'ExcelApp.Wait (Now + TimeValue("0:00:1"))
        End If
     End If
    Next RowNumber
    
    Workbook.Close savechanges:=True
    
    Debug.Print "Done"

End Sub
Sub SendExcelFuelUpdate()
    
    Debug.Print "-------------------------------"
    
    Dim ExcelFile   As String
    Dim ExcelApp    As Excel.Application
    Dim Workbook         As Excel.Workbook
    Dim WorkSheet        As Excel.WorkSheet
    Dim EntireRange  As Excel.Range
    Dim Cell        As Range
    Dim Row As Range
    Dim ValidEmailAddress As Boolean
    Dim FirstSent As Boolean
        Dim SecondSent As Boolean
    Dim Today As Date
    Dim EmailAddress As String
    Dim Counter As Integer
    
    ValidEmail = False
    
    ExcelFile = "C:\Users\guygu\OneDrive\Rainier\Email HTML Templates\jimmyjohns.xlsx"
    
    Set ExcelApp = CreateObject("Excel.Application")
    Set Workbook = ExcelApp.Workbooks.Open(ExcelFile)
    Set WorkSheet = Workbook.Sheets(1)
    WorkSheet.Activate
    Set EntireRange = WorkSheet.Range("A1:A10")
    EntireRange.Activate
    ExcelApp.Visible = False
    
    Today = Now
    Counter = 0
    
 For RowNumber = 1 To 874

        ValidEmailAddress = False
        EmailAddress = Trim(WorkSheet.Cells(RowNumber, 9))
        If Len(EmailAddress) > 0 Then ValidEmailAddress = True
        If ValidEmailAddress = True Then
            Counter = Counter + 1
            If Counter < 2 Then
                Debug.Print (EmailAddress)
                SendEmail (EmailAddress)
                ExcelApp.Wait (Now + TimeValue("0:00:1"))
            End If
        End If
    Next RowNumber
    
    Workbook.Close savechanges:=True
    
    Debug.Print "Done"

    
End Sub


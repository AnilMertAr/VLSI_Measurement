%Data Acquisition Script
DIRECTORY='C:\Users\anilm\OneDrive\Masaüstü\HCI_2\HCI_2\'; %Directory of the Experiment folder, Where all the datas exist.
HCI_Files=dir(DIRECTORY); %Directory of the data
% Do not forget to write a script that creates tables automatically.

Row_Names={'Chip No';'Transistor No';'Transistor_Type';'Measurement_Type';'Temperature';'Stress_Voltage';'Measurement Time';'Fine';'Result'};
Data_Storage=cell2table(Row_Names);

Chip_No=0;
Transistor_No=0;
Measurement_Type=0;
Measurement_Time=0;
Fine=0;                 %Table parameters
Temperature=300;
Stress_Voltage=2;
Transistor_Type='';
Result=zeros(112,10);

Stress_Time=0; % A parameter unrelated to the ones above.

Global_Column_Number=2; % A variable that stores the next column in which the data will be inserted.

for i=3:length(HCI_Files)

Parameters=split(HCI_Files(i).name,"_");
Measurement_Type=Parameters(2);             %Assigning Table parameters specific to Folders
Chip_No=Parameters(3);

if(strcmp(Parameters(4),"FINE"))
Fine=1;
else                                        %Determining wheter the measurement is FINE 
    Fine=0;
end

Table_Files=dir(strcat(DIRECTORY,HCI_Files(i).name)); %Setting the directory of the chosen file. 

for k=3:length(Table_Files)        % k starts with 3 because the first 2 data seems to be '.' and '..'
                    

ExcelParse=split(Table_Files(k).name,"_");

if(strcmp(ExcelParse(1),"ID")==0)
continue;                           %Checking whether the file contains the experimental data.
end

Type=split(ExcelParse(length(ExcelParse)),'.');
Transistor_Type=Type(1);                             % Assigning Table parameters related to specific transistors.
Transistor_No=ExcelParse(length(ExcelParse)-1);


for Stress_Time=0:4
    Str_Range=[" ";":";" "]; 
Fir_Range=112*Stress_Time+1;        % This part adjusts how many rows should be taken.
Las_Range=112*(Stress_Time+1);

Str_Range(1,:)=num2str(Fir_Range);
Str_Range(3,:)=num2str(Las_Range);                        %Creating Str variable in order to parametrize the string input of
Row_Range=strcat(Str_Range(1),Str_Range(2),Str_Range(3)); %readtable() function.

fullfileName=fullfile(Table_Files(1).folder,Table_Files(k).name);
Result=readtable(fullfileName,'Range',Row_Range);

Result=table2cell(Result);
Data_Column={Chip_No;Transistor_No;Transistor_Type;Measurement_Type;Temperature;Stress_Voltage;Stress_Time;Fine;Result};
Data_Storage(:,Global_Column_Number)=Data_Column;
Global_Column_Number=Global_Column_Number+1;

end
end
end 
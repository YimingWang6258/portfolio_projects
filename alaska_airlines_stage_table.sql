SET DEFINE OFF
CREATE TABLE YW_AL_STAGE ( Activity_Period NUMBER(38),
Operating_Airline VARCHAR2(128),
Operating_Airline_IATA_Code VARCHAR2(26),
Published_Airline VARCHAR2(128),
Published_Airline_IATA_Code VARCHAR2(128),
GEO_Summary VARCHAR2(128),
GEO_Region VARCHAR2(128),
Activity_Type_Code VARCHAR2(128),
Price_Category_Code VARCHAR2(128),
Terminal_Description VARCHAR2(128),
Boarding_Area VARCHAR2(128),
Passenger_Count NUMBER(38));

/* .ctl .sh and .bat files are found in /Users/wangyiming/Desktop/Database Design and Management/Alaska Airlines/Alaska Airlines stage. */

select * from yw_al_stage

function getDay(selectDay){
  var optn = document.createElement("option");
  optn.value = "";
  optn.text = " ";
  selectDay.options.add(optn);

  for(var i=1; i<=31; i++){
    var optn = document.createElement("option");
    optn.value = i;
    optn.text = i;
    selectDay.options.add(optn);
  }
  return selectDay;
}

function getMonth(selectMonth){
  months = new Array([1, "January"],
                     [2, "Febuary"],
                     [3, "March"],
                     [4, "April"],
                     [5, "May"],
                     [6, "June"],
                     [7, "July"],
                     [8, "Agust"],
                     [9, "September"],
                     [10, "Oktober"],
                     [11, "November"],
                     [12, "Desember"])
  
  var optn = document.createElement("option");
  optn.value = "";
  optn.text = " ";
  selectMonth.options.add(optn);
  
  for(var i=0; i<months.length; i++){
    var optn = document.createElement("option");
    optn.value = months[i][0];
    optn.text = months[i][1];
    selectMonth.options.add(optn);
  }
  return selectMonth;
}

function getYear(selectYear){
  y = new Date();
  y = y.getFullYear();
  
  var optn = document.createElement("option");
  optn.value = "";
  optn.text = " ";
  selectYear.options.add(optn);
  var optn = document.createElement("option");
  optn.value = y;
  optn.text = y;
  selectYear.options.add(optn);

  for(var i=1; i<=10; i++){
    var optn = document.createElement("option");
    optn.value = y-i;
    optn.text = y-i;
    selectYear.options.add(optn);
  }
  return selectYear;
}

window.counter = 1;
function addRowAddress(){
  var inputLocType    = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][location_type]", type: "text"});
  var inputStreet1    = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][street_1]", type: "text"});
  var inputStreet2    = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][street_2]", type: "text"});
  var selectCountry   = new Element('select', { Class: "textbox5", name: "addresses["+window.counter+"][country_id]", id: "country-id"});
  
    var optn = document.createElement("option");
    optn.value = 0;
    optn.text = "  ";
    selectCountry.options.add(optn);

  for(var i=0; i< window.countries.length; i++){
    var optn = document.createElement("option");
    optn.value = window.countries[i][0];
    optn.text = window.countries[i][1];
    selectCountry.options.add(optn);
  }
  
  selectCountry.writeAttribute('onchange', 'getRegion(this.value,\''+window.counter+'\')');
    
  var selectRegion = new Element('select', { Class: "textbox5", name: "addresses["+window.counter+"][region_id]", id: "region-id"});
  var opt = document.createElement("option");
  opt.value = "1";
  opt.text = "Select Region First";
  selectRegion.options.add(opt);
  
  var inputCity       = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][city]", type: "text"});
  var inputPostalCode = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][postal_code]", type: "text"});
  var selectMoveInDay    = new Element('select', { name: "addresses["+window.counter+"][day_in]", type: "text"});
  var selectMoveInMonth    = new Element('select', { name: "addresses["+window.counter+"][month_in]", type: "text"});
  var selectMoveInYear    = new Element('select', { name: "addresses["+window.counter+"][year_in]", type: "text"});
  var selectMoveOutDay   = new Element('select', { name: "addresses["+window.counter+"][day_out]", type: "text"});
  var selectMoveOutMonth   = new Element('select', { name: "addresses["+window.counter+"][month_out]", type: "text"});
  var selectMoveOutYear   = new Element('select', { name: "addresses["+window.counter+"][year_out]", type: "text"});

  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-address"});
  
  var tr1 = new Element('tr', {});
    var td1 = new Element('td', {colspan: "3"});
      var div1 = new Element('div', {Class: "title6"});
      var linkCancel = new Element('a', { href:"#", onClick:'deleteFormAddress();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
      var div6 = new Element('div', {id: "select-region-"+window.counter});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr8 = new Element('tr');
    var td81 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td82 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr9 = new Element('tr');
    var td91 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td92 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td93 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr10 = new Element('tr');
    var td101 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td102 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td103 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr11 = new Element('tr');
    var td111 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td112 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td113 = new Element('td', {Class: "coll-form3", valign:"center"});

  //tr1
  div1.innerHTML = "Add New Address";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
  	td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Location Type";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputLocType);

  //tr11
  td111.innerHTML = "Street1";
  td112.innerHTML = ":";
  tr11.appendChild(td111);
  tr11.appendChild(td112);
  tr11.appendChild(td113);
    td113.appendChild(inputStreet1);

  //tr4
  td41.innerHTML = "Street2";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(inputStreet2);

  //tr5
  td51.innerHTML = "Country";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(selectCountry);

  //tr6
  td61.innerHTML = "Region";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(div6);
      div6.appendChild(selectRegion);

  //tr7
  td71.innerHTML = "City";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(inputCity);

  //tr8
  td81.innerHTML = "Postal Code";
  td82.innerHTML = ":";
  tr8.appendChild(td81);
  tr8.appendChild(td82);
  tr8.appendChild(td83);
    td83.appendChild(inputPostalCode);

  //tr9
  td91.innerHTML = "Move In";
  td92.innerHTML = ":";
  tr9.appendChild(td91);
  tr9.appendChild(td92);
  tr9.appendChild(td93);
    td93.appendChild(getDay(selectMoveInDay));
    td93.appendChild(getMonth(selectMoveInMonth));
    td93.appendChild(getYear(selectMoveInYear));

  //tr10
  td101.innerHTML = "Move Out";
  td102.innerHTML = ":";
  tr10.appendChild(td101);
  tr10.appendChild(td102);
  tr10.appendChild(td103);
    td103.appendChild(getDay(selectMoveOutDay));
    td103.appendChild(getMonth(selectMoveOutMonth));
    td103.appendChild(getYear(selectMoveOutYear));
  
  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr11);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  divParent.appendChild(tr8);
  divParent.appendChild(tr9);
  divParent.appendChild(tr10);
  $('table-addresses').appendChild(divParent);
  $('save-button-address').show();
  
  window.counter++
}


window.counter_job = 1;
function addRowJob(){
  var inputCompany     = new Element('input', { Class: "textbox5", name: "jobs["+window.counter_job+"][company]", type: "text"});
  var inputTitle       = new Element('input', { Class: "textbox5", name: "jobs["+window.counter_job+"][title]", type: "text"});
  var inputDescription = new Element('textarea', { name: "jobs["+window.counter_job+"][description]", rows: "5", cols: "10"});
  var selectStartDay      = new Element('select', { name: "jobs["+window.counter_job+"][start_day]"});
  var selectStartMonth      = new Element('select', { name: "jobs["+window.counter_job+"][start_month]"});
  var selectStartYear      = new Element('select', { name: "jobs["+window.counter_job+"][start_year]"});
  var selectEndDay        = new Element('select', { name: "jobs["+window.counter_job+"][end_day]"});
  var selectEndMonth        = new Element('select', { name: "jobs["+window.counter_job+"][end_month]"});
  var selectEndYear        = new Element('select', { name: "jobs["+window.counter_job+"][end_year]"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-job"});
  
  var tr1 = new Element('tr', {});
    var td1 = new Element('td', {colspan: "3"});
      var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormJob();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  //tr1
  div1.innerHTML = "Add New Job";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Company";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputCompany);

  //tr4
  td41.innerHTML = "Title";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(inputTitle);

  //tr5
  td51.innerHTML = "Description";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(inputDescription);

  //tr6
  td61.innerHTML = "Start At";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(getDay(selectStartDay));
    td63.appendChild(getMonth(selectStartMonth));
    td63.appendChild(getYear(selectStartYear));

  //tr7
  td71.innerHTML = "End At";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(getDay(selectEndDay));
    td73.appendChild(getMonth(selectEndMonth));
    td73.appendChild(getYear(selectEndYear));

  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  $('table-jobs').appendChild(divParent);
  $('save-button-job').show();
  
  window.counter_job++
}

window.counter_school = 1;
function addRowSchool(){
  var inputName         = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][name]", type: "text"});
  var inputDegree       = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][degree]", type: "text"});
  var inputFields       = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][fields]", type: "text"});
  var selectStartDay       = new Element('select', { name: "schools["+window.counter_school+"][start_day]"});
  var selectStartMonth       = new Element('select', { name: "schools["+window.counter_school+"][start_month]"});
  var selectStartYear       = new Element('select', { name: "schools["+window.counter_school+"][start_year]"});
  var selectEndDay         = new Element('select', { name: "schools["+window.counter_school+"][end_day]"});
  var selectEndMonth         = new Element('select', { name: "schools["+window.counter_school+"][end_month]"});
  var selectEndYear         = new Element('select', { name: "schools["+window.counter_school+"][end_year]"});
  var inputActivities   = new Element('textarea', { name: "schools["+window.counter_school+"][activities_societies]", rows: "5", cols: "10"});
  var inputAwards       = new Element('textarea', { name: "schools["+window.counter_school+"][awards]", rows: "5", cols: "10"});
  var inputRecognitions = new Element('textarea', { name: "schools["+window.counter_school+"][recognitions]", rows: "5", cols: "10"});
  var inputNotes        = new Element('textarea', { name: "schools["+window.counter_school+"][notes]", rows: "5", cols: "10"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-school"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormSchool();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr8 = new Element('tr');
    var td81 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td82 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr9 = new Element('tr');
    var td91 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td92 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td93 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr10 = new Element('tr');
    var td101 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td102 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td103 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr11 = new Element('tr');
    var td111 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td112 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td113 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  //tr1
  div1.innerHTML = "Add New School";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Name";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputName);

  //tr4
  td41.innerHTML = "Degree";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(inputDegree);

  //tr5
  td51.innerHTML = "Fields";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(inputFields);

  //tr6
  td61.innerHTML = "Start At";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(getDay(selectStartDay));
    td63.appendChild(getMonth(selectStartMonth));
    td63.appendChild(getYear(selectStartYear));

  //tr7
  td71.innerHTML = "End At";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(getDay(selectEndDay));
    td73.appendChild(getMonth(selectEndMonth));
    td73.appendChild(getYear(selectEndYear));

  //tr7
  td81.innerHTML = "Activities";
  td82.innerHTML = ":";
  tr8.appendChild(td81);
  tr8.appendChild(td82);
  tr8.appendChild(td83);
    td83.appendChild(inputActivities);

  //tr7
  td91.innerHTML = "Awards";
  td92.innerHTML = ":";
  tr9.appendChild(td91);
  tr9.appendChild(td92);
  tr9.appendChild(td93);
    td93.appendChild(inputAwards);

  //tr7
  td101.innerHTML = "Recognitions";
  td102.innerHTML = ":";
  tr10.appendChild(td101);
  tr10.appendChild(td102);
  tr10.appendChild(td103);
    td103.appendChild(inputRecognitions);

  //tr7
  td111.innerHTML = "Notes";
  td112.innerHTML = ":";
  tr11.appendChild(td111);
  tr11.appendChild(td112);
  tr11.appendChild(td113);
    td113.appendChild(inputNotes);
  
  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  divParent.appendChild(tr8);
  divParent.appendChild(tr9);
  divParent.appendChild(tr10);
  divParent.appendChild(tr11);  
  $('table-schools').appendChild(divParent);
  $('save-button-school').show();
  
  window.counter_school++
}

window.counter_medical = 1;
function addRowMedical(){
  var inputBlood          = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][blood_type]", type: "text"});
  var inputDisorder       = new Element('textarea', { Class: "textbox5", name: "medicals["+window.counter_medical+"][disorder]", rows: "5", cols: "10"});
  var inputPhysicianName  = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][physician_name]", type: "text"});
  var inputPhysicianPhone = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][physician_phone]", type: "text"});
  var inputDentistName    = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][dentist_name]", type: "text"});
  var inputDentistPhone   = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][dentist_phone]", type: "text"});
  var inputNotes          = new Element('textarea', { Class: "textbox5", name: "medicals["+window.counter_medical+"][notes]", rows: "5", cols: "10"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-medical"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormMedical();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr8 = new Element('tr');
    var td81 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td82 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr9 = new Element('tr');
    var td91 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td92 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td93 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  //tr1
  div1.innerHTML = "Add New Medical";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Blood Type";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputBlood);

  //tr4
  td41.innerHTML = "Disorder";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(inputDisorder);

  //tr5
  td51.innerHTML = "Physician Name";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(inputPhysicianName);

  //tr6
  td61.innerHTML = "Physician Phone";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(inputPhysicianPhone);

  //tr7
  td71.innerHTML = "Dentist Name";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(inputDentistName);

  //tr7
  td81.innerHTML = "Dentist Phone";
  td82.innerHTML = ":";
  tr8.appendChild(td81);
  tr8.appendChild(td82);
  tr8.appendChild(td83);
    td83.appendChild(inputDentistPhone);

  //tr7
  td91.innerHTML = "Notes";
  td92.innerHTML = ":";
  tr9.appendChild(td91);
  tr9.appendChild(td92);
  tr9.appendChild(td93);
    td93.appendChild(inputNotes);
  
  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  divParent.appendChild(tr8);
  divParent.appendChild(tr9);
  $('table-medicals').appendChild(divParent);
  $('save-button-medical').show();
  
  window.counter_medical++
}

window.counter_medical_condition = 1;
function addRowMedicalCondition(){
  var inputName       = new Element('input', { Class: "textbox5", name: "medical_conditions["+window.counter_medical_condition+"][name]", type: "text"});
  var inputDiagnosis  = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][diagnosis]", rows: "5", cols: "10"});
  var inputTreatment  = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][treatment]", rows: "5", cols: "10"});
  var inputNotes      = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][notes]", rows: "5", cols: "10"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-medical-condition"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormMedicalCondition();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
   
  //tr1
  div1.innerHTML = "Add New Medical Condition";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Name";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputName);

  //tr4
  td41.innerHTML = "Diagnosis";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(inputDiagnosis);

  //tr5
  td51.innerHTML = "Treatment";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(inputTreatment);

  //tr6
  td61.innerHTML = "Notes";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(inputNotes);
  
  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  $('table-medical-conditions').appendChild(divParent);
  $('save-button-medical-condition').show();
  
  window.counter_medical_condition++
}

window.counter_family = 1;
function addRowFamily(){
  var inputName        = new Element('input', { Class: "textbox5", name: "families["+window.counter_family+"][name]", type: "text" });
  var inputHiddenField = new Element('input', { Class: "textbox5", name: "families["+window.counter_family+"][family_type]", type: "text", style: "display:none;", id:"custom-family-type-"+window.counter_family });
  var selectType       = new Element('select', { Class: "textbox5", name: "families["+window.counter_family+"][family_type]", id:"select-family-type-"+window.counter_family });
    
    var optn = document.createElement("option");
    optn.value = "-";
    optn.text = "  ";
    selectType.options.add(optn);
    
    for(var i=0; i< window.types.length; i++){
    var optn = document.createElement("option");
    optn.value = window.types[i][0];
    optn.text = window.types[i][1];
    selectType.options.add(optn);
    }
  
  var selectBirtdateDay  = new Element('select', { name: "families["+window.counter_family+"][birtdate_day]"});
  var selectBirtdateMonth  = new Element('select', { name: "families["+window.counter_family+"][birtdate_month]"});
  var selectBirtdateYear  = new Element('select', { name: "families["+window.counter_family+"][birtdate_year]"});
  var inputLiving     = new Element('input', { Class: "textbox5", name: "families["+window.counter_family+"][living]", type: "checkbox", value:"1", checked:"checked"});
  var inputNotes      = new Element('textarea', { name: "families["+window.counter_family+"][notes]", rows: "5", cols: "10"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-family"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormFamily();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var linkOther = new Element('a', { href:"#", onClick:'toggleCustomTextFamily('+window.counter_family+');', id:"link-family-other-"+window.counter_family });
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextFamily('+window.counter_family+');', style:"display:none;", id:"link-family-back-"+window.counter_family });

  //tr1
  div1.innerHTML = "Add New Family";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Name";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputName);

  //tr4
  linkOther.innerHTML = "Other";
  linkBack.innerHTML = "Back";
  td41.innerHTML = "Type";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(selectType);
    td43.appendChild(linkOther);
    td43.appendChild(linkBack);
    td43.appendChild(inputHiddenField);

  //tr5
  td51.innerHTML = "Birthdate";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(getDay(selectBirtdateDay));
    td53.appendChild(getMonth(selectBirtdateMonth));
    td53.appendChild(getYear(selectBirtdateYear));

  //tr6
  td61.innerHTML = "Living";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(inputLiving);

  //tr7
  td71.innerHTML = "Notes";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(inputNotes);

  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  $('table-families').appendChild(divParent);
  $('save-button-family').show();
  
  window.counter_family++
}

window.counter_relationship = 1;
function addRowRelationship(){
  var inputName        = new Element('input', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][name]", type: "text"});
  var inputHiddenField = new Element('input', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][circle_id]", type: "text", style:"display:none", id:"custom-relation-type-"+window.counter_relationship });
  var selectType       = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][circle_id]", id:"select-relation-type-"+window.counter_relationship });
    
    var optn = document.createElement("option");
    optn.value = "-";
    optn.text = "  ";
    selectType.options.add(optn);
    
    for(var i=0; i< window.types_relationship.length; i++){

    var optn = document.createElement("option");
    optn.value = window.types_relationship[i][0];
    optn.text = window.types_relationship[i][1];
    selectType.options.add(optn);
    }
  
  var selectStartDay     = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][start_day]"});
  var selectStartMonth     = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][start_month]"});
  var selectStartYear     = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][start_year]"});
  var selectEndDay       = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][end_day]"});
  var selectEndMonth       = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][end_month]"});
  var selectEndYear       = new Element('select', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][end_year]"});
  var inputNotes      = new Element('textarea', { name: "relationships["+window.counter_relationship+"][notes]", rows: "5", cols: "10"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-relationship"});
  
 var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'deleteFormRelationship();', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var linkOther = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', id:"link-relation-back-"+window.counter_relationship });
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', style:"display:none;", id:"link-relation-other-"+window.counter_relationship });
  
  //tr1
  div1.innerHTML = "Add New Relationship";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
    td1.appendChild(linkCancel);
    
  //tr2
  tr2.appendChild(td2);
    td2.appendChild(hr);

  //tr3
  td31.innerHTML = "Name";
  td32.innerHTML = ":";
  tr3.appendChild(td31);
  tr3.appendChild(td32);
  tr3.appendChild(td33);
    td33.appendChild(inputName);

  //tr4
  linkOther.innerHTML = "Other";
  linkBack.innerHTML = "Back";
  td41.innerHTML = "Type";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(selectType);
    td43.appendChild(linkOther);
    td43.appendChild(linkBack);
    td43.appendChild(inputHiddenField);

  //tr5
  td51.innerHTML = "Start At";
  td52.innerHTML = ":";
  tr5.appendChild(td51);
  tr5.appendChild(td52);
  tr5.appendChild(td53);
    td53.appendChild(getDay(selectStartDay));
    td53.appendChild(getMonth(selectStartMonth));
    td53.appendChild(getYear(selectStartYear));

  //tr6
  td61.innerHTML = "Start End";
  td62.innerHTML = ":";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(getDay(selectEndDay));
    td63.appendChild(getMonth(selectEndMonth));
    td63.appendChild(getYear(selectEndYear));

  //tr7
  td71.innerHTML = "Notes";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(inputNotes);

  divParent.appendChild(tr1);
  divParent.appendChild(tr2);
  divParent.appendChild(tr3);
  divParent.appendChild(tr4);
  divParent.appendChild(tr5);
  divParent.appendChild(tr6);
  divParent.appendChild(tr7);
  $('table-relationships').appendChild(divParent);
  $('save-button-relationship').show();
  
  window.counter_relationship++
}

function toggleCustomTextRelation(id){
  $('select-relation-type-'+id).toggle();
  $('custom-relation-type-'+id).toggle();
  $('link-relation-back-'+id).toggle();
  $('link-relation-other-'+id).toggle();
}

function toggleCustomTextFamily(id){
  $('select-family-type-'+id).toggle();
  $('custom-family-type-'+id).toggle();
  $('link-family-back-'+id).toggle();
  $('link-family-other-'+id).toggle();
}

function getRegion(val,elementId){
  new Ajax.Request('account_settings/select_region/'+val, {asynchronous:true, evalScripts:true, method:'get',parameters:'cols_id='+elementId+'' });return false;
}

function deleteFormAddress(){
  $('add-new-address').remove();  
  $('save-button-address').hide();
}

function deleteFormJob(){
  $('add-new-job').remove();    
  $('save-button-job').hide();
}

function deleteFormSchool(){
  $('add-new-school').remove();
  $('save-button-school').hide();
}

function deleteFormMedical(){
  $('add-new-medical').remove();    
  $('save-button-medical').hide();
}

function deleteFormMedicalCondition(){
  $('add-new-medical-condition').remove();   
  $('save-button-medical-condition').hide();
}

function deleteFormFamily(){
  $('add-new-family').remove();
  $('save-button-family').hide();
}

function deleteFormRelationship(){
  $('add-new-relationship').remove();        
  $('save-button-relationship').hide();
}
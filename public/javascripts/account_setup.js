
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
  var selectMoveIn    = new Element('select', { Class: "textbox5", name: "", type: "text", id:'move-in'});
  var selectMoveOut   = new Element('select', { Class: "textbox5", name: "", type: "text"});
  
  var divParent = new Element('div', {Class: "popup-newbox", id:"add-new-address"});
  
  var tr1 = new Element('tr', {});
    var td1 = new Element('td', {colspan: "2"});
      var div1 = new Element('div', {Class: "title4"});
    var td11 = new Element('td', {align:"right", colspan: "2"});
       var linkCancel = new Element('a', { href:"#", onClick:'deleteRowAddress();', id:"link-", Class: "blue-btn3" });
 
  var tr2 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td41 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td42 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td51 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td52 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
      var div6 = new Element('div', {id: "select-region-"+window.counter});
  
  var tr7 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr8 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td81 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td82 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr9 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td91 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td92 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td93 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr10 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td101 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td102 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td103 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr11 = new Element('tr', { id:'add-new-address-'+window.counter});
    var td111 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td112 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td113 = new Element('td', {Class: "coll-form3", valign:"center"});

  //tr1
  
  div1.innerHTML = "Add New Address";
  linkCancel.innerHTML = "Cancel";
  tr1.appendChild(td1);
    td1.appendChild(div1);
  tr1.appendChild(td11);
    td11.appendChild(linkCancel);
    
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
    td93.appendChild(selectMoveIn);

  //tr10
  td101.innerHTML = "Move Out";
  td102.innerHTML = ":";
  tr10.appendChild(td101);
  tr10.appendChild(td102);
  tr10.appendChild(td103);
    td103.appendChild(selectMoveOut);
  
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
  var tr               = new Element('tr', { id:'add-new-job', Class:'form-job-'+window.counter_job});
  var inputCompany     = new Element('input', { name: "jobs["+window.counter_job+"][company]", type: "text"});
  var inputTitle       = new Element('input', { name: "jobs["+window.counter_job+"][title]", type: "text"});
  var inputDescription = new Element('textarea', { name: "jobs["+window.counter_job+"][description]", rows: "5", cols: "10"});
  var selectStart      = new Element('select', { name: "jobs["+window.counter_job+"][start_at]"});
  var selectEnd        = new Element('select', { name: "jobs["+window.counter_job+"][end_at]"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  var td6 = new Element('td', {bgcolor: "#333333"});
  var div6 = new Element('div', {align: "center"});
  var td7 = new Element('td', {bgcolor: "#333333"});
  var div7 = new Element('div', {align: "center"});
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowJob(\'form-job-'+window.counter_job+'\')');
  
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputCompany);
  
  //td2
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(inputTitle);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(inputDescription);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(selectStart);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(selectEnd);
  
  //td6
  tr.appendChild(td6);
  td6.appendChild(div6);
  div6.appendChild(selectStart);
  
  //td7
  tr.appendChild(td7);
  td7.appendChild(div7);
  div7.appendChild(btn);
  
  $('table-jobs').appendChild(tr);
  $('save-button-job').show();
  window.counter_job++
}

window.counter_school = 1;
function addRowSchool(){
  var tr                = new Element('tr', { id:'add-new-school', Class:'form-school-'+window.counter_school});
  var inputName         = new Element('input', { name: "schools["+window.counter_school+"][name]", type: "text"});
  var inputDegree       = new Element('input', { name: "schools["+window.counter_school+"][degree]", type: "text"});
  var inputFields       = new Element('input', { name: "schools["+window.counter_school+"][fields]", type: "text"});
  var selectStart       = new Element('select', { name: "schools["+window.counter_school+"][start_at]"});
  var selectEnd         = new Element('select', { name: "schools["+window.counter_school+"][end_at]"});
  var inputActivities   = new Element('textarea', { name: "schools["+window.counter_school+"][activities_societies]", rows: "5", cols: "10"});
  var inputAwards       = new Element('textarea', { name: "schools["+window.counter_school+"][awards]", rows: "5", cols: "10"});
  var inputRecognitions = new Element('textarea', { name: "schools["+window.counter_school+"][recognitions]", rows: "5", cols: "10"});
  var inputNotes        = new Element('textarea', { name: "schools["+window.counter_school+"][notes]", rows: "5", cols: "10"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  var td6 = new Element('td', {bgcolor: "#333333"});
  var div6 = new Element('div', {align: "center"});
  var td7 = new Element('td', {bgcolor: "#333333"});
  var div7 = new Element('div', {align: "center"});
  var td8 = new Element('td', {bgcolor: "#333333"});
  var div8 = new Element('div', {align: "center"});
  var td9 = new Element('td', {bgcolor: "#333333"});
  var div9 = new Element('div', {align: "center"});
  var td10 = new Element('td', {bgcolor: "#333333"});
  var div10 = new Element('div', {align: "center"});
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowSchool(\'form-school-'+window.counter_school+'\')');
  
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputName);
  
  //td2
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(inputDegree);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(inputFields);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(selectStart);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(selectEnd);
  
  //td6
  tr.appendChild(td6);
  td6.appendChild(div6);
  div6.appendChild(inputActivities);
  
  //td7
  tr.appendChild(td7);
  td7.appendChild(div7);
  div7.appendChild(inputAwards);
  
  //td8
  tr.appendChild(td8);
  td8.appendChild(div8);
  div8.appendChild(inputRecognitions);
  
  //td9
  tr.appendChild(td9);
  td9.appendChild(div9);
  div9.appendChild(inputNotes);
  
  //td10
  tr.appendChild(td10);
  td10.appendChild(div10);
  div10.appendChild(btn);
  
  $('table-schools').appendChild(tr);
  $('save-button-school').show();
  
  window.counter_school++
}

window.counter_medical = 1;
function addRowMedical(){
  var tr                  = new Element('tr', { id:'add-new-medical', Class:'form-medical-'+window.counter_medical});
  var inputBlood          = new Element('input', { name: "medicals["+window.counter_medical+"][blood_type]", type: "text"});
  var inputDisorder       = new Element('textarea', { name: "medicals["+window.counter_medical+"][disorder]", rows: "5", cols: "10"});
  var inputPhysicianName  = new Element('input', { name: "medicals["+window.counter_medical+"][physician_name]", type: "text"});
  var inputPhysicianPhone = new Element('input', { name: "medicals["+window.counter_medical+"][physician_phone]", type: "text"});
  var inputDentistName    = new Element('input', { name: "medicals["+window.counter_medical+"][dentist_name]", type: "text"});
  var inputDentistPhone   = new Element('input', { name: "medicals["+window.counter_medical+"][dentist_phone]", type: "text"});
  var inputNotes          = new Element('textarea', { name: "medicals["+window.counter_medical+"][notes]", rows: "5", cols: "10"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  var td6 = new Element('td', {bgcolor: "#333333"});
  var div6 = new Element('div', {align: "center"});
  var td7 = new Element('td', {bgcolor: "#333333"});
  var div7 = new Element('div', {align: "center"});
  var td8 = new Element('td', {bgcolor: "#333333"});
  var div8 = new Element('div', {align: "center"});
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowMedical(\'form-medical-'+window.counter_medical+'\')');
  
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputBlood);
  
  //td2
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(inputDisorder);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(inputPhysicianName);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(inputPhysicianPhone);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(inputDentistName);
  
  //td6
  tr.appendChild(td6);
  td6.appendChild(div6);
  div6.appendChild(inputDentistPhone);
  
  //td7
  tr.appendChild(td7);
  td7.appendChild(div7);
  div7.appendChild(inputNotes);
  
  //td8
  tr.appendChild(td8);
  td8.appendChild(div8);
  div8.appendChild(btn);
  
  $('table-medicals').appendChild(tr);
  $('save-button-medical').show();
  
  window.counter_medical++
}

window.counter_medical_condition = 1;
function addRowMedicalCondition(){
  var tr              = new Element('tr', { id:'add-new-medical-condition', Class:'form-medical-condition-'+window.counter_medical_condition});
  var inputName       = new Element('input', { name: "medical_conditions["+window.counter_medical_condition+"][name]", type: "text"});
  var inputDiagnosis  = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][diagnosis]", rows: "5", cols: "10"});
  var inputTreatment  = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][treatment]", rows: "5", cols: "10"});
  var inputNotes      = new Element('textarea', { name: "medical_conditions["+window.counter_medical_condition+"][notes]", rows: "5", cols: "10"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowMedicalCondition(\'form-medical-condition-'+window.counter_medical_condition+'\')');
  
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputName);
  
  //td2
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(inputDiagnosis);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(inputTreatment);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(inputNotes);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(btn);
  
  $('table-medical-conditions').appendChild(tr);
  $('save-button-medical-condition').show();
  
  window.counter_medical_condition++
}

window.counter_family = 1;
function addRowFamily(){
  var tr               = new Element('tr', { id:'add-new-family', Class:'form-familiy-'+window.counter_family });
  var inputName        = new Element('input', { name: "families["+window.counter_family+"][name]", type: "text" });
  var inputHiddenField = new Element('input', { name: "families["+window.counter_family+"][family_type]", type: "text", style: "display:none;", id:"custom-family-type-"+window.counter_family });
  var selectType       = new Element('select', { name: "families["+window.counter_family+"][family_type]", id:"select-family-type-"+window.counter_family });
    for(var i=0; i< window.types.length; i++){
    var optn = document.createElement("option");
    optn.value = window.types[i][0];
    optn.text = window.types[i][1];
    selectType.options.add(optn);
  }
  
  var selectBirtdate  = new Element('select', { name: "families["+window.counter_family+"][birtdate]"});
  var inputLiving     = new Element('input', { name: "families["+window.counter_family+"][living]", type: "checkbox", value:"1", checked:"checked"});
  var inputNotes      = new Element('textarea', { name: "families["+window.counter_family+"][notes]", rows: "5", cols: "10"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  var td6 = new Element('td', {bgcolor: "#333333"});
  var div6 = new Element('div', {align: "center"});
  
  var linkOther = new Element('a', { href:"#", onClick:'toggleCustomTextFamily('+window.counter_family+');', id:"link-family-other-"+window.counter_family });
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextFamily('+window.counter_family+');', style:"display:none;", id:"link-family-back-"+window.counter_family });
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowFamily(\'form-familiy-'+window.counter_family+'\')');
  
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputName);
  
  //td2
  linkOther.innerHTML = "Other";
  linkBack.innerHTML = "Back";
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(selectType);
  div2.appendChild(linkOther);
  div2.appendChild(linkBack);
  div2.appendChild(inputHiddenField);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(selectBirtdate);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(inputLiving);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(inputNotes);
  
  //td6
  tr.appendChild(td6);
  td6.appendChild(div6);
  div6.appendChild(btn);
  
  $('table-families').appendChild(tr);
  $('save-button-family').show();
  
  window.counter_family++
  
}

window.counter_relationship = 1;
function addRowRelationship(){
  var tr               = new Element('tr', { id:'add-new-relationship', Class:'form-relationship-'+window.counter_relationship});
  var inputName        = new Element('input', { name: "relationships["+window.counter_relationship+"][name]", type: "text"});
  var inputHiddenField = new Element('input', { name: "relationships["+window.counter_relationship+"][circle_id]", type: "text", style:"display:none", id:"custom-relation-type-"+window.counter_relationship });
  var selectType       = new Element('select', { name: "relationships["+window.counter_relationship+"][circle_id]", id:"select-relation-type-"+window.counter_relationship });
    for(var i=0; i< window.types_relationship.length; i++){
    var optn = document.createElement("option");
    optn.value = window.types_relationship[i][0];
    optn.text = window.types_relationship[i][1];
    selectType.options.add(optn);
  }
  
  var selectStart     = new Element('select', { name: "relationships["+window.counter_relationship+"][start_at]"});
  var selectEnd       = new Element('select', { name: "relationships["+window.counter_relationship+"][end_at]"});
  var inputNotes      = new Element('textarea', { name: "relationships["+window.counter_relationship+"][notes]", rows: "5", cols: "10"});
  
  var td1 = new Element('td', {bgcolor: "#333333"});
  var div1 = new Element('div', {align: "center"});
  var td2 = new Element('td', {bgcolor: "#333333"});
  var div2 = new Element('div', {align: "center"});
  var td3 = new Element('td', {bgcolor: "#333333"});
  var div3 = new Element('div', {align: "center"});
  var td4 = new Element('td', {bgcolor: "#333333"});
  var div4 = new Element('div', {align: "center"});
  var td5 = new Element('td', {bgcolor: "#333333"});
  var div5 = new Element('div', {align: "center"});
  var td6 = new Element('td', {bgcolor: "#333333"});
  var div6 = new Element('div', {align: "center"});
  
  var linkOther = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', id:"link-relation-back-"+window.counter_relationship });
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', style:"display:none;", id:"link-relation-other-"+window.counter_relationship });
  
  var btn = new Element('input', {type: "button", 'class': "btn-blue", value: "Cancel"});
  btn.writeAttribute('onclick', 'deleteRowRelationship(\'form-relationship-'+window.counter_relationship+'\')');
 
  //td1
  tr.appendChild(td1);
  td1.appendChild(div1);
  div1.appendChild(inputName);
  
  //td2
  linkOther.innerHTML = "Other";
  linkBack.innerHTML = "Back";
  tr.appendChild(td2);
  td2.appendChild(div2);
  div2.appendChild(selectType);
  div2.appendChild(linkOther);
  div2.appendChild(linkBack);
  div2.appendChild(inputHiddenField);
  
  //td3
  tr.appendChild(td3);
  td3.appendChild(div3);
  div3.appendChild(selectStart);
  
  //td4
  tr.appendChild(td4);
  td4.appendChild(div4);
  div4.appendChild(selectEnd);
  
  //td5
  tr.appendChild(td5);
  td5.appendChild(div5);
  div5.appendChild(inputNotes);
  
  //td6
  tr.appendChild(td6);
  td6.appendChild(div6);
  div6.appendChild(btn);
  
  $('table-relationships').appendChild(tr);
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

function deleteRowAddress(){
  $('add-new-address').remove();        
}

function deleteRowJob(child){
  $('table-history-jobs').getElementsByClassName(child)[0].remove();        
}

function deleteRowSchool(child){
  $('table-history-schools').getElementsByClassName(child)[0].remove();        
}

function deleteRowMedical(child){
  $('table-history-medicals').getElementsByClassName(child)[0].remove();        
}

function deleteRowMedicalCondition(child){
  $('table-history-medical-conditions').getElementsByClassName(child)[0].remove();        
}

function deleteRowFamily(child){
  $('table-history-families').getElementsByClassName(child)[0].remove();        
}

function deleteRowRelationship(child){
  $('table-history-relationships').getElementsByClassName(child)[0].remove();        
}
// global var oh no!
var scrollbar;

document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/spinner.gif'

    function createSpinner() {
      new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        el.up('.pagination').insert(createSpinner())
        new Ajax.Request(el.href, { asynchronous:true, evalScripts:true, method: 'get',
                        onLoading:function(request){$('progress-bar').show();}, 
                        onComplete:function(request){$('progress-bar').hide();} })
        e.stop()
      }
    })
  }
	Scroller.reset('account-setting-content');
  setDinamycHeight('account-setting-content');
 // scrollbar = new Control.ScrollBar('scrollbar_content','scrollbar_track');
});

// Callback for Facebook Backup App settings.
var on_facebook_backup_auth_close = function(check_url) {
	new Ajax.Request(check_url, { method: 'get',
		onSuccess:function(transport) {
			json = transport.responseText.evalJSON();
			
			if (json && json.authenticated) {
				$('fb-button').removeClassName('fb-btn2');
				$('fb-button').addClassName('fb-active');
			} else {
				$('fb-button').addClassName('fb-btn2');
				$('fb-button').removeClassName('fb-active');
			}
		}
	} );
}

function resizeScrollbar() {
	Scroller.reset('account-setting-content');
	//setDinamycHeight('account-setting-content');
	//scrollbar.recalculateLayout();  
}

function updateStep(check_url, completed_steps) {
	new Ajax.Request(check_url, {
		method: 'get',
		onSuccess:function(transport) {
			current_step = parseInt(transport.responseText);
			//alert('completed steps = ' + completed_steps + ' current step = ' + current_step);
			if (current_step > completed_steps) {
				//alert('displaying ' + 'step'+(current_step+1)+'-enabled');
				$('step'+(current_step+1)+'-enabled').show();
				$('step'+(current_step+1)+'-disabled').hide();
			}
		}
	});
}

function activatedFb(){
  parent.document.getElementById('fb-button').setAttribute('class', 'fb-active');
}

function setDinamycHeight(id){
  height = win_dimension()[1];
  heightDiv = 0.83*height;
  $(id).style.height = heightDiv + "px";
	resizeScrollbar();
}

function resetDinamycHeight(id){
  heightDiv = 350;
  $(id).style.height = heightDiv + "px";
  $(id).style.overflow = "hidden";
}

function resetDinamycHeightStepFour(id){
  heightDiv = 590;
  $(id).style.height = heightDiv + "px";
  $(id).style.overflow = "hidden";
}

function getDay(selectDay){
   for(var i=1; i<=31; i++){
    var optn = document.createElement("option");
    optn.value = i;
    optn.text = i;
    selectDay.options.add(optn);
  }
  return selectDay;
}

function getMonth(selectMonth){
  months = new Array([1, "Jan"],
                     [2, "Feb"],
                     [3, "Mar"],
                     [4, "Apr"],
                     [5, "May"],
                     [6, "Jun"],
                     [7, "Jul"],
                     [8, "Aug"],
                     [9, "Sep"],
                     [10, "Okt"],
                     [11, "Nov"],
                     [12, "Des"])
                   
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
  var imgLoading      = new Element('img', { src: "/images/spinner.gif", style: "display:none", id:"loading-image-"+window.counter });
  var selectCountry   = new Element('select', { Class: "textbox8", name: "addresses["+window.counter+"][country_id]", id: "country-id"});
  
    var optn = document.createElement("option");
    optn.value = "";
    optn.text = "Select Country";
    selectCountry.options.add(optn);

  for(var i=0; i< window.countries.length; i++){
    var optn = document.createElement("option");
    optn.value = window.countries[i][0];
    optn.text = window.countries[i][1];
    selectCountry.options.add(optn);
  }
  
  selectCountry.writeAttribute('onchange', 'getRegion(this.value,\''+window.counter+'\')');
    
  var selectRegion = new Element('select', { Class: "textbox8", name: "addresses["+window.counter+"][region_id]", id: "region-id", disabled: "disabled" });
  var opt = document.createElement("option");
  opt.value = "";
  opt.text = "Select Country First";
  selectRegion.options.add(opt);
  
  var inputCity       = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][city]", type: "text"});
  var inputPostalCode = new Element('input', { Class: "textbox5", name: "addresses["+window.counter+"][postal_code]", type: "text"});
  var selectMoveInDay    = new Element('select', { Class: "selectbox-day", name: "addresses["+window.counter+"][day_in]", type: "text"});
  var selectMoveInMonth    = new Element('select', { Class: "selectbox-month", name: "addresses["+window.counter+"][month_in]", type: "text"});
  var selectMoveInYear    = new Element('select', { Class: "selectbox-year", name: "addresses["+window.counter+"][year_in]", type: "text"});
  var selectMoveOutDay   = new Element('select', { Class: "selectbox-day", name: "addresses["+window.counter+"][end_day]", type: "text"});
  var selectMoveOutMonth   = new Element('select', { Class: "selectbox-month", name: "addresses["+window.counter+"][end_month]", type: "text"});
  var selectMoveOutYear   = new Element('select', { Class: "selectbox-year", name: "addresses["+window.counter+"][end_year]", type: "text"});

  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-address"});
  var checkBox = new Element('input', {id:"chekbox-addresses-"+window.counter, type:"checkbox"});
      checkBox.writeAttribute('onclick', 'toPresentText(\'addresses\',\''+window.counter+'\',\'Still living here?\')');
      
  var tr1 = new Element('tr');
    var td1 = new Element('td', {colspan: "3"});
      var div1 = new Element('div', {Class: "title6"});
      var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormAddress();}', Class: "blue-btn3" });
 
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
          var divTag = new Element('div', {id:"present-addresses-"+window.counter});
            var divTagDate = new Element('div', {id:"date-present-addresses-"+window.counter});
        var divCheckBox = new Element('div');
        var spanText = new Element('span', {id:"text-present-addresses-"+window.counter});
        
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
    td53.appendChild(imgLoading);

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
  spanText.innerHTML = "Still living here?";
  tr10.appendChild(td101);
  tr10.appendChild(td102);
  tr10.appendChild(td103);
    td103.appendChild(divTag);    
      divTag.appendChild(divTagDate);    
        divTagDate.appendChild(getDay(selectMoveOutDay));
        divTagDate.appendChild(getMonth(selectMoveOutMonth));
        divTagDate.appendChild(getYear(selectMoveOutYear));
        divTagDate.appendChild(divCheckBox);
          td103.appendChild(checkBox);
          td103.appendChild(spanText);
  
  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr11);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  tableParent.appendChild(tr8);
  tableParent.appendChild(tr9);
  tableParent.appendChild(tr10);
  $('table-form-address').appendChild(tableParent);
  $('save-button-address').show();    
  $('form_address').value = window.counter;    
  
  window.counter++;
	resizeScrollbar();
	
}


window.counter_job = 1;
function addRowJob(){
  var inputCompany     = new Element('input', { Class: "textbox5", name: "jobs["+window.counter_job+"][company]", type: "text"});
  var inputTitle       = new Element('input', { Class: "textbox5", name: "jobs["+window.counter_job+"][title]", type: "text"});
  var inputDescription = new Element('textarea', { Class: "textarea1", name: "jobs["+window.counter_job+"][description]", rows: "5", cols: "10"});
  var selectStartDay      = new Element('select', { Class: "selectbox-day", name: "jobs["+window.counter_job+"][start_day]"});
  var selectStartMonth      = new Element('select', { Class: "selectbox-month", name: "jobs["+window.counter_job+"][start_month]"});
  var selectStartYear      = new Element('select', { Class: "selectbox-year", name: "jobs["+window.counter_job+"][start_year]"});
  var selectEndDay        = new Element('select', { Class: "selectbox-day", name: "jobs["+window.counter_job+"][end_day]"});
  var selectEndMonth        = new Element('select', { Class: "selectbox-month", name: "jobs["+window.counter_job+"][end_month]"});
  var selectEndYear        = new Element('select', { Class: "selectbox-year", name: "jobs["+window.counter_job+"][end_year]"});
  var inputNotes = new Element('textarea', { Class: "textarea1", name: "jobs["+window.counter_job+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-job"});
    var checkBox = new Element('input', {id:"chekbox-jobs-"+window.counter_job, type:"checkbox"});
        checkBox.writeAttribute('onclick', 'toPresentText(\'jobs\',\''+window.counter_job+'\',\'Still work here?\')');
      
  var tr1 = new Element('tr', {});
    var td1 = new Element('td', {colspan: "3"});
      var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormJob();}', Class: "blue-btn3" });
 
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
    var td51 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td52 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td62 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td63 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td72 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
      var divTag = new Element('div', {id:"present-jobs-"+window.counter_job});
        var divTagDate = new Element('div', {id:"date-present-jobs-"+window.counter_job});
    var divCheckBox = new Element('div');
    var spanText = new Element('span', {id:"text-present-jobs-"+window.counter_job});
  
  var tr8 = new Element('tr');
    var td81 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td82 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
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
  spanText.innerHTML = "Still work here?";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(divTag);    
      divTag.appendChild(divTagDate);    
        divTagDate.appendChild(getDay(selectEndDay));
        divTagDate.appendChild(getMonth(selectEndMonth));
        divTagDate.appendChild(getYear(selectEndYear));
        divTagDate.appendChild(divCheckBox);
    td73.appendChild(checkBox);
    td73.appendChild(spanText);

  //tr8
  td81.innerHTML = "Notes";
  td82.innerHTML = ":";
  tr8.appendChild(td81);
  tr8.appendChild(td82);
  tr8.appendChild(td83);
    td83.appendChild(inputNotes);

  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  tableParent.appendChild(tr8);
  $('table-form-job').appendChild(tableParent);
  $('save-button-job').show();
  $('form_job').value = window.counter_job;
  
  window.counter_job++
	resizeScrollbar();
}

window.counter_school = 1;
function addRowSchool(){
  var inputName         = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][name]", type: "text"});
  var inputDegree       = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][degree]", type: "text"});
  var inputFields       = new Element('input', { Class: "textbox5", name: "schools["+window.counter_school+"][fields]", type: "text"});
  var selectStartDay       = new Element('select', { Class: "selectbox-day", name: "schools["+window.counter_school+"][start_day]"});
  var selectStartMonth       = new Element('select', { Class: "selectbox-month", name: "schools["+window.counter_school+"][start_month]"});
  var selectStartYear       = new Element('select', { Class: "selectbox-year", name: "schools["+window.counter_school+"][start_year]"});
  var selectEndDay         = new Element('select', { Class: "selectbox-day", name: "schools["+window.counter_school+"][end_day]"});
  var selectEndMonth         = new Element('select', { Class: "selectbox-month", name: "schools["+window.counter_school+"][end_month]"});
  var selectEndYear         = new Element('select', { Class: "selectbox-year", name: "schools["+window.counter_school+"][end_year]"});
  var inputActivities   = new Element('textarea', { Class: "textarea1", name: "schools["+window.counter_school+"][activities_societies]", rows: "5", cols: "10"});
  var inputAwards       = new Element('textarea', { Class: "textarea1", name: "schools["+window.counter_school+"][awards]", rows: "5", cols: "10"});
  var inputRecognitions = new Element('textarea', { Class: "textarea1", name: "schools["+window.counter_school+"][recognitions]", rows: "5", cols: "10"});
  var inputNotes        = new Element('textarea', { Class: "textarea1", name: "schools["+window.counter_school+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-school"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormSchool();}', Class: "blue-btn3" });
 
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
    var td81 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td82 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td83 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr9 = new Element('tr');
    var td91 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td92 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td93 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr10 = new Element('tr');
    var td101 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td102 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td103 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr11 = new Element('tr');
    var td111 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td112 = new Element('td', {Class: "coll-form2b", valign:"top"});
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
  
  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  tableParent.appendChild(tr8);
  tableParent.appendChild(tr9);
  tableParent.appendChild(tr10);
  tableParent.appendChild(tr11);  
  $('table-form-school').appendChild(tableParent);
  $('save-button-school').show();
  $('form_school').value = window.counter_school;
  
  window.counter_school++
	resizeScrollbar();
}

window.counter_medical = 1;
function addRowMedical(){
  var inputBlood          = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][blood_type]", type: "text"});
  var inputDisorder       = new Element('textarea', { Class: "textarea1", name: "medicals["+window.counter_medical+"][disorder]", rows: "5", cols: "10"});
  var inputPhysicianName  = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][physician_name]", type: "text"});
  var inputPhysicianPhone = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][physician_phone]", type: "text"});
  var inputDentistName    = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][dentist_name]", type: "text"});
  var inputDentistPhone   = new Element('input', { Class: "textbox5", name: "medicals["+window.counter_medical+"][dentist_phone]", type: "text"});
  var inputNotes          = new Element('textarea', { Class: "textarea1", name: "medicals["+window.counter_medical+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-medical"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormMedical();}', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1", valign:"center"});
    var td32 = new Element('td', {Class: "coll-form2", valign:"center"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td42 = new Element('td', {Class: "coll-form2b", valign:"top"});
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
    var td91 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td92 = new Element('td', {Class: "coll-form2b", valign:"top"});
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
  
  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  tableParent.appendChild(tr8);
  tableParent.appendChild(tr9);
  $('table-form-medical').appendChild(tableParent);
  $('save-button-medical').show();
  $('form_medical').value = window.counter_medical;
  
  window.counter_medical++
	resizeScrollbar();

}

window.counter_medical_condition = 1;
function addRowMedicalCondition(){
  var inputName       = new Element('input', { Class: "textbox5", name: "medical_conditions["+window.counter_medical_condition+"][name]", type: "text"});
  var inputDiagnosis  = new Element('textarea', { Class: "textarea1", name: "medical_conditions["+window.counter_medical_condition+"][diagnosis]", rows: "5", cols: "10"});
  var inputTreatment  = new Element('textarea', { Class: "textarea1", name: "medical_conditions["+window.counter_medical_condition+"][treatment]", rows: "5", cols: "10"});
  var inputNotes      = new Element('textarea', { Class: "textarea1", name: "medical_conditions["+window.counter_medical_condition+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-medical-condition"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormMedicalCondition();}', Class: "blue-btn3" });
 
  var tr2 = new Element('tr');
    var td2 = new Element('td', {colspan: "3"});
      var hr = new Element('hr', {Class: "line1"});
  
  var tr3 = new Element('tr');
    var td31 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td32 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td33 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr4 = new Element('tr');
    var td41 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td42 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td43 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr5 = new Element('tr');
    var td51 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td52 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td53 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var tr6 = new Element('tr');
    var td61 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td62 = new Element('td', {Class: "coll-form2b", valign:"top"});
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
  
  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  $('table-form-medical-condition').appendChild(tableParent);
  $('save-button-medical-condition').show();
  $('form_medical_condition').value = window.counter_medical_condition;
  
  window.counter_medical_condition++
	resizeScrollbar();
}

window.counter_family = 1;
function addRowFamily(){
  var inputName        = new Element('input', { Class: "textbox5", name: "families["+window.counter_family+"][name]", type: "text" });
  var inputHiddenField = new Element('input', { Class: "textbox5", name: "families["+window.counter_family+"][family_type]", type: "text", style: "display:none;", id:"custom-family-type-"+window.counter_family });
  var selectType       = new Element('select', { Class: "selectbox-type", name: "families["+window.counter_family+"][family_type]", id:"select-family-type-"+window.counter_family });
      selectType.writeAttribute('onChange', 'showOtherTextbox(this.value,\''+window.counter_family+'\')'); 
      
    for(var i=0; i< window.types.length; i++){
    var optn = document.createElement("option");
    optn.value = window.types[i][0];
    optn.text = window.types[i][1];
    selectType.options.add(optn);
    }
  
  var selectBirtdateDay  = new Element('select', { Class: "selectbox-day", name: "families["+window.counter_family+"][birtdate_day]"});
  var selectBirtdateMonth  = new Element('select', { Class: "selectbox-month", name: "families["+window.counter_family+"][birtdate_month]"});
  var selectBirtdateYear  = new Element('select', { Class: "selectbox-year", name: "families["+window.counter_family+"][birtdate_year]"});
  var inputLiving     = new Element('input', { name: "families["+window.counter_family+"][living]", type: "checkbox", value:"1", checked:"checked" });
  var inputNotes      = new Element('textarea', { Class: "textarea1", name: "families["+window.counter_family+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-family"});
  
  var tr1 = new Element('tr', {});
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
		var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormFamily();}', Class: "blue-btn3" });
 
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
    var td71 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td72 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextFamily('+window.counter_family+');', style:"display:none;", id:"link-family-back-"+window.counter_family, Class:'blue-btn4' });

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
  linkBack.innerHTML = "Cancel";
  td41.innerHTML = "Type";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(selectType);
    td43.appendChild(inputHiddenField);
    td43.appendChild(linkBack);

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

  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  $('table-form-family').appendChild(tableParent);
  $('save-button-family').show();
  $('form_family').value = window.counter_family;
  
  window.counter_family++;
	resizeScrollbar();
}

window.counter_relationship = 1;
function addRowRelationship(){
  var inputName        = new Element('input', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][name]", type: "text"});
  var inputHiddenField = new Element('input', { Class: "textbox5", name: "relationships["+window.counter_relationship+"][circle_id]", type: "text", style:"display:none", id:"custom-relation-type-"+window.counter_relationship });
  var selectType       = new Element('select', { Class: "selectbox-type", name: "relationships["+window.counter_relationship+"][circle_id]", id:"select-relation-type-"+window.counter_relationship });
       
    for(var i=0; i< window.types_relationship.length; i++){

    var optn = document.createElement("option");
    optn.value = window.types_relationship[i][0];
    optn.text = window.types_relationship[i][1];
    selectType.options.add(optn);
    }
  
  var selectStartDay     = new Element('select', { Class: "selectbox-day", name: "relationships["+window.counter_relationship+"][start_day]"});
  var selectStartMonth     = new Element('select', { Class: "selectbox-month", name: "relationships["+window.counter_relationship+"][start_month]"});
  var selectStartYear     = new Element('select', { Class: "selectbox-year", name: "relationships["+window.counter_relationship+"][start_year]"});
  var selectEndDay       = new Element('select', { Class: "selectbox-day", name: "relationships["+window.counter_relationship+"][end_day]"});
  var selectEndMonth       = new Element('select', { Class: "selectbox-month", name: "relationships["+window.counter_relationship+"][end_month]"});
  var selectEndYear       = new Element('select', { Class: "selectbox-year", name: "relationships["+window.counter_relationship+"][end_year]"});
  var inputNotes      = new Element('textarea', { Class: "textarea1", name: "relationships["+window.counter_relationship+"][notes]", rows: "5", cols: "10"});
  
  var tableParent = new Element('table', {Class: "popup-newbox", id:"add-new-relationship"});
  var checkBox = new Element('input', {id:"chekbox-relationships-"+window.counter_relationship, type:"checkbox"});
        checkBox.writeAttribute('onclick', 'toPresentText(\'relationships\',\''+window.counter_relationship+'\',\'Still married to this person?\')');
 var tr1 = new Element('tr');
  var td1 = new Element('td', {colspan: "3"});
    var div1 = new Element('div', {Class: "title6"});
	var linkCancel = new Element('a', { href:"#", onClick:'if(confirm("Are you sure?") == true){deleteFormRelationship();}', Class: "blue-btn3" });
 
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
        var divTag = new Element('div', {id:"present-relationships-"+window.counter_relationship});
      var divTagDate = new Element('div', {id:"date-present-relationships-"+window.counter_relationship});
    var divCheckBox = new Element('div');
    var spanText = new Element('span', {id:"text-present-relationships-"+window.counter_relationship});
  
  var tr7 = new Element('tr');
    var td71 = new Element('td', {Class: "coll-form1b", valign:"top"});
    var td72 = new Element('td', {Class: "coll-form2b", valign:"top"});
    var td73 = new Element('td', {Class: "coll-form3", valign:"center"});
  
  var linkOther = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', id:"link-relation-back-"+window.counter_relationship, Class:'blue-btn4' });
  var linkBack  = new Element('a', { href:"#", onClick:'toggleCustomTextRelation('+window.counter_relationship+');', style:"display:none;", id:"link-relation-other-"+window.counter_relationship, Class:'blue-btn4' });
  
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
  linkBack.innerHTML = "Cancel";
  td41.innerHTML = "Type";
  td42.innerHTML = ":";
  tr4.appendChild(td41);
  tr4.appendChild(td42);
  tr4.appendChild(td43);
    td43.appendChild(selectType);
    td43.appendChild(inputHiddenField);
    td43.appendChild(linkOther);
    td43.appendChild(linkBack);

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
  spanText.innerHTML = "Still married to this person?";
  tr6.appendChild(td61);
  tr6.appendChild(td62);
  tr6.appendChild(td63);
    td63.appendChild(divTag);
    divTag.appendChild(divTagDate);    
      divTagDate.appendChild(getDay(selectEndDay));
      divTagDate.appendChild(getMonth(selectEndMonth));
      divTagDate.appendChild(getYear(selectEndYear));
      divTagDate.appendChild(divCheckBox);
    td63.appendChild(checkBox);
    td63.appendChild(spanText);

  //tr7
  td71.innerHTML = "Notes";
  td72.innerHTML = ":";
  tr7.appendChild(td71);
  tr7.appendChild(td72);
  tr7.appendChild(td73);
    td73.appendChild(inputNotes);

  tableParent.appendChild(tr1);
  tableParent.appendChild(tr2);
  tableParent.appendChild(tr3);
  tableParent.appendChild(tr4);
  tableParent.appendChild(tr5);
  tableParent.appendChild(tr6);
  tableParent.appendChild(tr7);
  $('table-form-relationship').appendChild(tableParent);
  $('save-button-relationship').show();
  $('form_relationship').value = window.counter_relationship;
  
  window.counter_relationship++;
	resizeScrollbar();
}

function createDateElement(text, val){
  var selectMoveOutDay   = new Element('select', { Class: "selectbox-day", name: ''+text+'['+val+'][end_day]', type: "text"});
  var selectMoveOutMonth   = new Element('select', { Class: "selectbox-month", name: ''+text+'['+val+'][end_month]', type: "text"});
  var selectMoveOutYear   = new Element('select', { Class: "selectbox-year", name: ''+text+'['+val+'][end_year]', type: "text"});
  var divTagDate = new Element('div', {id:'date-present-'+text+'-'+val+''});
  
  var content = $('present-'+text+'-'+val+'');
  
  divTagDate.appendChild(getDay(selectMoveOutDay));
  divTagDate.appendChild(getMonth(selectMoveOutMonth));
  divTagDate.appendChild(getYear(selectMoveOutYear));
  content.appendChild(divTagDate);
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
  document.getElementById('select-family-type-'+id+'').selectedIndex=0;
}

function getRegion(val,elementId){
  new Ajax.Request('account_settings/select_region/'+val, {asynchronous:true, evalScripts:true, method:'get',parameters:'cols_id='+elementId+'',
                   onLoading:function(request){$('loading-image-'+elementId).show();}, 
                   onComplete:function(request){$('loading-image-'+elementId).hide();} });return false;
}

function deleteFormAddress(){
  $('add-new-address').remove();  
  if ($('form_address').value == "1"){
    $('save-button-address').hide();
    window.counter = 1;
  }else{
    val = $('form_address').value;
    $('form_address').value =(val - 1);
  }
}

function deleteFormJob(){
  $('add-new-job').remove();    
  if ($('form_job').value == "1"){
    $('save-button-job').hide();
    window.counter_job = 1;
  }else{
    val = $('form_job').value;
    $('form_job').value =(val - 1);
  }
}

function deleteFormSchool(){
  $('add-new-school').remove();
  if ($('form_school').value == "1"){
    $('save-button-school').hide();
    window.counter_school = 1;
  }else{
    val = $('form_school').value;
    $('form_school').value =(val - 1);
  }
}

function deleteFormMedical(){
  $('add-new-medical').remove();    
  if ($('form_medical').value == "1"){
    $('save-button-medical').hide();
    window.counter_medical = 1;
  }else{
    val = $('form_medical').value;
    $('form_medical').value =(val - 1);
  }
}

function deleteFormMedicalCondition(){
  $('add-new-medical-condition').remove();   
  if ($('form_medical_condition').value == "1"){
    $('save-button-medical-condition').hide();
    window.counter_medical_condition = 1;
  }else{
    val = $('form_medical_condition').value;
    $('form_medical_condition').value =(val - 1);
  }
}

function deleteFormFamily(){
  $('add-new-family').remove();
  if ($('form_family').value == "1"){
    $('save-button-family').hide();
    window.counter_family = 1;
  }else{
    val = $('form_family').value;
    $('form_family').value =(val - 1);
  }
}

function deleteFormRelationship(){
  $('add-new-relationship').remove();        
  if ($('form_relationship').value == "1"){
    $('save-button-relationship').hide();
    window.counter_relationship = 1;
  }else{
    val = $('form_relationship').value;
    $('form_relationship').value =(val - 1);
  }
}

function showOtherTextbox(val, id){
  if(val=='Other'){
    $('select-family-type-'+id).toggle();
    $('custom-family-type-'+id).toggle();
    $('link-family-back-'+id).toggle();
  }
}

function toPresentText(text, val, description){
  if(val){
    var content = $('present-'+text+'-'+val+'');
    if(content.innerHTML==""){
      createDateElement(text, val);
      $('text-present-'+text+'-'+val+'').innerHTML = description;
    }else{
      $('date-present-'+text+'-'+val+'').remove();  
      $('text-present-'+text+'-'+val+'').innerHTML = "<b>To Present<b>";
    }
  } 
}

function rstCountAddress(){
  window.counter = 1;
}

function rstCountJob(){
  window.counter_job = 1;
}

function rstCountSchool(){
  window.counter_school = 1;
}

function rstCountMedical(){
  window.counter_medical = 1;
}

function rstCountMedicalCondition(){
  window.counter_medical_condition = 1;
}

function rstCountFamily(){
  window.counter_family = 1;
}

function rstCountRelationship(){
  window.counter_relationship = 1;
}
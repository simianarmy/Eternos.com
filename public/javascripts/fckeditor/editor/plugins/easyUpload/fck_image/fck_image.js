/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2008 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * Scripts related to the Image dialog window (see fck_image.html).
 */

var dialog		= window.parent ;

function Import(aSrc) {
   document.write('<scr'+'ipt type="text/javascript" src="' + aSrc + '"></sc' + 'ript>');
}

// Adds a Help button to the parent dialog pointing to the provided url
function SetupHelpButton( url )
{
	var doc = window.parent.document ;
	var helpButton = doc.createElement( 'INPUT' ) ;
	helpButton.type = 'button' ;
	helpButton.value = FCKLang.Help ;
	helpButton.className = 'Button' ;
	helpButton.onclick = function () { window.open( url ); return false; };

	var okButton = doc.getElementById( 'btnOk' ) ;
	var cell = okButton.parentNode.previousSibling ;
	if (cell.nodeName != 'TD')
			cell = cell.previousSibling ;
	cell.appendChild( helpButton );
}

var oEditor		= window.parent.InnerDialogLoaded() ;
var FCK			= oEditor.FCK ;
var FCKLang		= oEditor.FCKLang ;
var FCKConfig	= oEditor.FCKConfig ;
var FCKDebug	= oEditor.FCKDebug ;
var FCKTools	= oEditor.FCKTools ;

Import(FCKConfig.FullBasePath + 'dialog/common/fck_dialog_common.js');

//#### Dialog Tabs


// Get the selected image (if available).
var oImage = FCK.Selection.GetSelectedElement() ;

if ( oImage && oImage.tagName != 'IMG' )
	oImage = null ;

var oImageOriginal ;

function UpdateOriginal( resetSize )
{
	if ( !eImgPreview )
		return ;
		
	oImageOriginal = document.createElement( 'IMG' ) ;	// new Image() ;

	if ( resetSize )
	{
		oImageOriginal.onload = function()
		{
			this.onload = null ;
			ResetSizes() ;
		}
	}

	oImageOriginal.src = eImgPreview.src ;
}

var bPreviewInitialized ;

window.onload = function()
{
	// Fill the classes combo
	var aClasses = oEditor.GetAvailableClasses( 'img' ) ;
	var oCombo = GetE('cmbClass');
	for ( var i = 0 ; i < aClasses.length ; i++ )
		FCKTools.AddSelectOption( oCombo, aClasses[i].name, aClasses[i].classname ) ;

	GetE('btnLockSizes').style.display = 'none';
	GetE('txtUrl').style.display = 'none';
	
	// Add an optional Help button
	if ( FCKConfig.EasyUpload_ImageHelpURL && FCKConfig.EasyUpload_ImageHelpURL.length > 0 )
		SetupHelpButton( FCKConfig.EasyUpload_ImageHelpURL ) ;

	// Show/Hide the "Browse Server" and paste from external URL and button.
	GetE('fromServer').style.display				= FCKConfig.ImageBrowser	? '' : 'none' ;
	GetE('fromExternal').style.display				= FCKConfig.EasyUpload_AllowPasteURL	? '' : 'none' ;

	GetE('txtPaste').style.width = '100%' ;
	GetE('txtPaste').onfocus = function() {if (this.value==this.defaultValue) this.select(); } ;

	// Automatically send the file
	GetE('txtUploadFile').onchange = function() { if (this.value!="") Ok(); } ;
	


	// Translate the dialog box texts.
	oEditor.FCKLanguageManager.TranslatePage(document) ;

	GetE('btnLockSizes').title = FCKLang.DlgImgLockRatio ;
	GetE('btnResetSize').title = FCKLang.DlgEuBtnResetSize ;

	// Load the selected element information (if any).
	LoadSelection() ;
	
	UpdateOriginal() ;

	// Set the actual uploader URL.
	GetE('frmUpload').action = FCKConfig.ImageUploadURL ;

	dialog.SetAutoSize( true ) ;

	// Activate the "OK" button.
//	window.parent.SetOkButton( true ) ;
}

function LoadSelection()
{
	if ( ! oImage ) {
		GetE("txtUploadFile").focus();
		return ;
	}

	//hide upload and show properties fields
	GetE("divProperties").style.display  = '';
	GetE("divUpload").style.display  = 'none';

	window.parent.SetOkButton( true ) ;

	var sUrl = GetAttribute( oImage, '_fcksavedurl', '' ) ;
	if ( sUrl.length == 0 )
		sUrl = GetAttribute( oImage, 'src', '' ) ;


	GetE('txtUrl').value    = sUrl ;
	GetE('txtAlt').value    = GetAttribute( oImage, 'alt', '' ) ;
	GetE('txtVSpace').value	= GetAttribute( oImage, 'vspace', '' ) ;
	GetE('txtHSpace').value	= GetAttribute( oImage, 'hspace', '' ) ;
	GetE('txtBorder').value	= GetAttribute( oImage, 'border', '' ) ;
	GetE('cmbAlign').value	= GetAttribute( oImage, 'align', '' ) ;

	var iWidth, iHeight ;

	var regexSize = /^\s*(\d+)px\s*$/i ;
	
	if ( oImage.style.width )
	{
		var aMatchW  = oImage.style.width.match( regexSize ) ;
		if ( aMatchW )
		{
			iWidth = aMatchW[1] ;
			oImage.style.width = '' ;
			SetAttribute( oImage, 'width' , iWidth ) ;
		}
	}

	if ( oImage.style.height )
	{
		var aMatchH  = oImage.style.height.match( regexSize ) ;
		if ( aMatchH )
		{
			iHeight = aMatchH[1] ;
			oImage.style.height = '' ;
			SetAttribute( oImage, 'height', iHeight ) ;
		}
	}

	GetE('txtWidth').value	= iWidth ? iWidth : GetAttribute( oImage, "width", '' ) ;
	GetE('txtHeight').value	= iHeight ? iHeight : GetAttribute( oImage, "height", '' ) ;

	// Class
	GetE('cmbClass').value = oImage.className ;

	UpdatePreview() ;
}

//#### The OK button was hit.
function Ok()
{
	//check if the user has selected a file to upload (we're overiding the default behaviour of the link dialog)
	var sFile = GetE('txtUploadFile').value ;
	if (sFile.length > 0) 
	{
		//upload the file
		if ( CheckUpload() )
		{
			// Start the throbber timer.
			window.parent.Throbber.Show( 100 ) ;
			GetE("divUpload").style.display  = 'none';

			GetE('frmUpload').submit();
		}
		return false ; //we'll finish once the file is at the server
	}

	if ( GetE('txtUrl').value.length == 0 && GetE('txtPaste').value != GetE('txtPaste').defaultValue)
	{
		SetUrl( GetE('txtPaste').value) ;
		return false;
	}

	if ( GetE('txtUrl').value.length == 0 )
	{
		alert( FCKLang.EuSelectAnImage );
		return false ;
	}

	var bHasImage = ( oImage != null ) ;

	if ( !bHasImage )
	{
		oImage = FCK.CreateElement( 'IMG' ) ;

		//Alfonso: if the image hasn't been inserted get out
		if ( !oImage )
			return true ;
	}
	else
		oEditor.FCKUndo.SaveUndoStep() ;
	
	UpdateImage( oImage ) ;

	return true ;
}

function UpdateImage( e, skipId )
{
	e.src = GetE('txtUrl').value ;
	SetAttribute( e, "_fcksavedurl", GetE('txtUrl').value ) ;
	SetAttribute( e, "alt"   , GetE('txtAlt').value ) ;
	SetAttribute( e, "width" , GetE('txtWidth').value ) ;
	SetAttribute( e, "height", GetE('txtHeight').value ) ;
	SetAttribute( e, "vspace", GetE('txtVSpace').value ) ;
	SetAttribute( e, "hspace", GetE('txtHSpace').value ) ;
	SetAttribute( e, "border", GetE('txtBorder').value ) ;
	SetAttribute( e, "align" , GetE('cmbAlign').value ) ;

//	SetAttribute( e, 'title'	, GetE('txtAttTitle').value ) ;
/*
	if ( oEditor.FCKBrowserInfo.IsIE )
		e.style.cssText = "" ; //GetE('txtAttStyle').value ;
	else
		SetAttribute( e, 'style', "" ); //GetE('txtAttStyle').value ) ;
*/
	e.style.display = '';
	// Class
	e.className = GetE('cmbClass').value ;
}

var eImgPreview ;
var eImgPreviewLink ;

function SetPreviewElements( imageElement, linkElement )
{
	eImgPreview = imageElement ;
	eImgPreviewLink = linkElement ;

	UpdatePreview() ;
	UpdateOriginal() ;
	
	bPreviewInitialized = true ;
}

function UpdatePreview()
{
	if ( !eImgPreview || !eImgPreviewLink )
		return ;

	if ( GetE('txtUrl').value.length == 0 )
		eImgPreviewLink.style.display = 'none' ;
	else
	{
		UpdateImage( eImgPreview, true ) ;
		eImgPreviewLink.style.display = '' ;

	}
}

var bLockRatio = true ;

function SwitchLock( lockButton )
{
	bLockRatio = !bLockRatio ;
	lockButton.className = bLockRatio ? 'BtnLocked' : 'BtnUnlocked' ;
	lockButton.title = bLockRatio ? 'Lock sizes' : 'Unlock sizes' ;

	if ( bLockRatio )
	{
		if ( GetE('txtWidth').value.length > 0 )
			OnSizeChanged( 'Width', GetE('txtWidth').value ) ;
		else
			OnSizeChanged( 'Height', GetE('txtHeight').value ) ;
	}
}

// Fired when the width or height input texts change
function OnSizeChanged( dimension, value )
{
	// Verifies if the aspect ration has to be mantained
	if ( oImageOriginal && bLockRatio )
	{
		var e = dimension == 'Width' ? GetE('txtHeight') : GetE('txtWidth') ;
		
		if ( value.length == 0 || isNaN( value ) )
		{
			e.value = '' ;
			return ;
		}

		if ( dimension == 'Width' )
			value = value == 0 ? 0 : Math.round( oImageOriginal.height * ( value  / oImageOriginal.width ) ) ;
		else
			value = value == 0 ? 0 : Math.round( oImageOriginal.width  * ( value / oImageOriginal.height ) ) ;

		if ( !isNaN( value ) )
			e.value = value ;
	}

	UpdatePreview() ;
}

// Fired when the Reset Size button is clicked
function ResetSizes()
{
	if ( ! oImageOriginal ) return ;
	if ( oEditor.FCKBrowserInfo.IsGecko && !oImageOriginal.complete )
	{
		setTimeout( ResetSizes, 50 ) ;
		return ;
	}

	GetE('txtWidth').value  = oImageOriginal.width ;
	GetE('txtHeight').value = oImageOriginal.height ;

	UpdatePreview() ;
}

function BrowseServer()
{
	OpenServerBrowser(
		'Image',
		FCKConfig.ImageBrowserURL,
		FCKConfig.ImageBrowserWindowWidth,
		FCKConfig.ImageBrowserWindowHeight ) ;
}

function LnkBrowseServer()
{
	OpenServerBrowser(
		'Link',
		FCKConfig.LinkBrowserURL,
		FCKConfig.LinkBrowserWindowWidth,
		FCKConfig.LinkBrowserWindowHeight ) ;
}

function OpenServerBrowser( type, url, width, height )
{
	sActualBrowser = type ;
	OpenFileBrowser( url, width, height ) ;
}

var sActualBrowser ;

function SetUrl( url, width, height, alt )
{
	if ( sActualBrowser == 'Link' )
	{
		GetE('txtLnkUrl').value = url ;
		UpdatePreview() ;
	}
	else
	{
		GetE('txtUrl').value = url ;
		GetE('txtWidth').value = width ? width : '' ;
		GetE('txtHeight').value = height ? height : '' ;

		if ( alt )
			GetE('txtAlt').value = alt;

		UpdatePreview() ;
		UpdateOriginal( true ) ;
	}

	dialog.SetSelectedTab( 'Info' ) ;

	//hide upload and show properties fields
	GetE("divProperties").style.display  = '';
	GetE("divUpload").style.display  = 'none';

	// Activate the "OK" button.
	window.parent.SetOkButton( true ) ;
}

function OnUploadCompleted( errorNumber, fileUrl, fileName, customMsg )
{
	window.parent.Throbber.Hide() ;

	switch ( errorNumber )
	{
		case 0 :	// No errors
//			alert( 'Your file has been successfully uploaded' ) ;
			break ;
		case 1 :	// Custom error
			alert( customMsg ) ;
			return ;
		case 101 :	// Custom warning
			alert( customMsg ) ;
			break ;
		case 201 :
//			alert( 'A file with the same name is already available. The uploaded file has been renamed to "' + fileName + '"' ) ;
			break ;
		case 202 :
			alert( 'Invalid file type' ) ;
			return ;
		case 203 :
			alert( "Security error. You probably don't have enough permissions to upload. Please check your server." ) ;
			return ;
		default :
			alert( 'Error on file upload. Error number: ' + errorNumber ) ;
			return ;
	}

	sActualBrowser = '' ;
	GetE('frmUpload').reset() ;

	// Set the url if we had only a warning or it was succesful
	if (errorNumber == 0 || errorNumber == 101  || errorNumber == 201 )
		SetUrl( fileUrl ) ;
}

var oUploadAllowedExtRegex	= new RegExp( FCKConfig.ImageUploadAllowedExtensions, 'i' ) ;
var oUploadDeniedExtRegex	= new RegExp( FCKConfig.ImageUploadDeniedExtensions, 'i' ) ;

function CheckUpload()
{
	var sFile = GetE('txtUploadFile').value ;
	
	if ( sFile.length == 0 )
	{
		alert( 'Please select a file to upload' ) ;
		return false ;
	}
	
	if ( ( FCKConfig.ImageUploadAllowedExtensions.length > 0 && !oUploadAllowedExtRegex.test( sFile ) ) ||
		( FCKConfig.ImageUploadDeniedExtensions.length > 0 && oUploadDeniedExtRegex.test( sFile ) ) )
	{
		OnUploadCompleted( 202 ) ;
		return false ;
	}
	
	return true ;
}

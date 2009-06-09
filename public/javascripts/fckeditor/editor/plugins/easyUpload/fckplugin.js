/*
 *
 * File Name: fckplugin.js
 * 	Plugin to provide easy dialogs to upload images and files
 * 
 * File Authors:
 * 		Alfonso Martínez de Lizarrondo
 *
 * Developed for Graham Glass
 *
 * Version: 0.3 
 */

//Image Dialog
// Register the related command.
FCKCommands.RegisterCommand( 'easyImage', new FCKDialogCommand( 'easyImage', FCKLang.EuImgDialogTitle, FCKPlugins.Items['easyUpload'].Path + 'fck_image.html', 450, 350 ) ) ;

// Create the toolbar button.
var oEasyImageItem = new FCKToolbarButton( 'easyImage', FCKLang.EuInsertImageLbl, FCKLang.EuInsertImage, null, false, true, 37) ;

FCKToolbarItems.RegisterItem( 'easyImage', oEasyImageItem ) ;



//File Dialog
// Register the related command.
FCKCommands.RegisterCommand( 'easyFile', new FCKDialogCommand( 'easyImage', FCKLang.EuFileDialogTitle, FCKPlugins.Items['easyUpload'].Path + 'fck_file.html', 340, 250 ) ) ;

// Create the toolbar button.
var oEasyFileItem = new FCKToolbarButton( 'easyFile', FCKLang.EuFileInsertFileLbl, FCKLang.EuFileInsertFile, null, false, true) ;
oEasyFileItem.IconPath = FCKPlugins.Items['easyUpload'].Path + 'file.gif' ;

FCKToolbarItems.RegisterItem( 'easyFile', oEasyFileItem ) ;



//External Link Dialog
// Register the related command.
FCKCommands.RegisterCommand( 'easyLink', new FCKDialogCommand( 'easyImage', FCKLang.EuLinkDialogTitle, FCKPlugins.Items['easyUpload'].Path + 'fck_link.html', 340, 180 ) ) ;

// Create the toolbar button.
var oEasyLinkItem = new FCKToolbarButton( 'easyLink', FCKLang.EuInsertLinkLbl, FCKLang.EuInsertLink, null, false, true, 34) ;

FCKToolbarItems.RegisterItem( 'easyLink', oEasyLinkItem ) ;



// Context menu for Image and Link
// Define the context menu "listener".
var oMyContextMenuListener = { 
	// We will use our own menus only if the default ones have been removed from the config, so if someone uses just the 
	// image dialog then we don' mess with the links (for example)
	EnableImageMenu : (FCKConfig.ContextMenu.IndexOf('Image') == -1) ,
 
	EnableLinkMenu : (FCKConfig.ContextMenu.IndexOf('Link') == -1) ,

// This is the standard function called right before sowing the context menu.
	AddItems : function( menu, tag, tagName )
	{
		if ( this.EnableImageMenu && tagName == 'IMG' && !tag.getAttribute( '_fckfakelement' ) )
		{
			menu.AddSeparator() ;
			menu.AddItem( 'easyImage', FCKLang.EuMenuImageProperties, 37 ) ;
		}

		if ( this.EnableLinkMenu && FCK.GetNamedCommandState( 'Unlink' ) != FCK_TRISTATE_DISABLED )
		{
			menu.AddSeparator() ;
			menu.AddItem( 'easyLink'	, FCKLang.EuMenuEditLink		, 34 ) ;
			menu.AddItem( 'Unlink'	, FCKLang.EuMenuRemoveLink	, 35 ) ; //calls the default one
		}
	}

}

// Register our context menu listener.
FCK.ContextMenu.RegisterListener( oMyContextMenuListener ) ;




// Returns an array with the available classes defined in the Styles
GetAvailableClasses = function( nodeName ) 
{
	var styles = FCK.Styles.GetStyles() ;
	var aClasses = [{name:'', classname:''}];

	for ( var styleName in styles )
	{
		var style = styles[styleName] ;
		if (style.IsCore)
			continue;

		if (style.Element == nodeName)
		{
			if (style._StyleDesc.Attributes && style._StyleDesc.Attributes['class'] ) 
				aClasses.push( {name:styleName, classname:style._StyleDesc.Attributes['class']} ) ;
		}
	}

	return aClasses ;
}
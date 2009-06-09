# $Id$
#!/bin/bash

svn status | grep "^\?" | awk "{print $2}" | xargs svn add

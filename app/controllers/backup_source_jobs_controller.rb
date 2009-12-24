# $Id$

class BackupSourceJobsController < ApplicationController
  # for Ajax calls to determine job progress
  def progress
    @job ||= BackupSourceJob.find(params[:id])
    respond_to do |format|
      format.js { 
        render :inline => @job.percent_complete
      }
    end
  end
end
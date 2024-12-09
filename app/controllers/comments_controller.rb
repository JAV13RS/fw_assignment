class CommentsController < ApplicationController
    before_action :set_comment, only: [:destroy]
  
  
    def destroy
      @comment.destroy
      redirect_back(fallback_location: root_path, notice: 'Comment deleted successfully.')
    end
  
    private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  
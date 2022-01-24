class HomesController < ApplicationController

  def index
    MemesCleanupJob.perform_later
    @user = User.find(current_user.id) if current_user
    @meme = Meme.new
    @tag = Tag.new
    
    if params[:filter]
      case params[:filter]
      when "best_today"
        @memes = Meme.joins(:likes).group('memes.id').order('Count(likes.id) DESC').where(lang: I18n.locale, created_at: Date.today.beginning_of_day..Date.today.end_of_day)
      when "best_week"
        @memes = Meme.joins(:likes).group('memes.id').order('Count(likes.id) DESC').where(lang: I18n.locale, created_at: Date.today - 7..Date.today.end_of_day)
      when "best_month"
        @memes = Meme.joins(:likes).group('memes.id').order('Count(likes.id) DESC').where(lang: I18n.locale, created_at: Date.today - 30..Date.today.end_of_day)
      when "best_all_time"
        @memes = Meme.joins(:likes).group('memes.id').order('Count(likes.id) DESC').where(lang: I18n.locale)
      end
    elsif params[:tag]
      @memes = Tag.find_by(name: params[:tag]).memes.where(lang: I18n.locale)
    elsif params[:user]
      user_id = User.find_by(username: params[:user]).id
      @memes = Meme.where(user_id: user_id)
    else
      @memes = Meme.all.where(lang: I18n.locale).order(created_at: :desc)
    end
    prepare_statistic
    @memes = pagination(@memes)
  end

  private

  def pagination(array)
    @page = params[:page] || 1
    @limit = params[:limit] || 6
    @page = @page.to_i
    @limit = @limit.to_f
    @max_page = (array.length.to_f / @limit).ceil
    array[(@page -1) * @limit, @limit]
  end

  def prepare_statistic
    return unless current_user
    @statistic_best_memes = Meme.joins(:likes).group('memes.id').order('Count(likes.id) DESC').where(user_id: current_user.id).limit(5)
  end

end
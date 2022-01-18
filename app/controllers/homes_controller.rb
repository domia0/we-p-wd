class HomesController < ApplicationController

  def index
    MemesCleanupJob.perform_later
    @user = User.find(current_user.id) if current_user
    @meme = Meme.new
    @tag = Tag.new
    
    if params[:filter]
      @memes = []
      case params[:filter]
      when "best_today"
        sort_memes_by_likes(Meme.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_week"
        sort_memes_by_likes(Meme.where(created_at: Date.today - 7..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_month"
        sort_memes_by_likes(Meme.where(created_at: Date.today - 30..Date.today.end_of_day))
          .each {|item| @memes.push(item["meme"])}
      when "best_all_time"
        sort_memes_by_likes(Meme.all).each {|item| @memes.push(item["meme"])}
      end
    elsif params[:tag]
      @memes = Tag.find_by(name: params[:tag]).memes
    elsif params[:user]
      user_id = User.find_by(username: params[:user]).id
      @memes = Meme.where(user_id: user_id)
    else
      @memes = Meme.all.order(created_at: :desc)
    end
    @memes = pagination(@memes)
  end

  private
  def sort_memes_by_likes(array)
    to_sort = []
    array.each do |m|
      new_obj = {}
      new_obj.store('meme', m)
      new_obj.store('likes', m.likes.count)
      to_sort.push(new_obj)
    end
    to_sort.sort_by! {|item| item['likes']}.reverse
  end

  def pagination(array)
    @page = params[:page] || 1
    @limit = params[:limit] || 6
    @page = @page.to_i
    @limit = @limit.to_f
    @max_page = (array.count.to_f / @limit).ceil
    array[(@page -1) * @limit, @limit]
  end

end
module LikesHelper
    def liked?(object)
        if Like.find_by(user_id: current_user&.id, likeable: object)
            return true
        else
            return false
        end
    end

    def get_like(object)
        return Like.find_by(user_id: current_user&.id, likeable: object)
    end
end

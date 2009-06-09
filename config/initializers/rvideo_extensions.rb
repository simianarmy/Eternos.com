# $Id$

module RVideo
  class Inspector
    def full_bitrate
      "#{bitrate} #{bitrate_units}"
    end
  end
end

function [fig_h, ax_h, leg_h, fig_v, ax_v, leg_v, fig_dh, ax_dh, leg_dh] = ...
             getInitFigs(draw_evol, draw_err)
    if(draw_evol)
        [fig_h, ax_h, leg_h] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
        view(-37.5, 30);    

        if(draw_err)
            [fig_dh, ax_dh, leg_dh] = getFig('x', 'y', 'dh(x,y)', '', '', '', 'dh');
            view(-37.5, 30);        
        end

        [fig_v, ax_v, leg_v] = getFig('x', 'y', '$\vec{v}(x,y)$');
    else
        fig_h = [];
        ax_h = [];
        leg_h = [];
        fig_dh = [];
        ax_dh = [];
        leg_dh = [];
        fig_v = [];
        ax_v = [];
        leg_v = [];
    end

end
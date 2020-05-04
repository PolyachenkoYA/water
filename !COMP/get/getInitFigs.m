function figs = getInitFigs(fmt)
    if(fmt.to_draw_evol)
        figs.fig_h = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
        view(-37.5, 30);    

        if(fmt.to_draw_err)
            figs.fig_dh = getFig('x', 'y', 'dh(x,y)', '', '', '', 'dh');
            view(-37.5, 30);        
        end

        figs.fig_v = getFig('x', 'y', '$\vec{v}(x,y)$');
    else
        figs = [];
    end

end
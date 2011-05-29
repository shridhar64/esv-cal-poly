function fig_generate

close all

% other options
label_font_size = 14;
tick_font_size = 10;
line_width = 3;
figure_name = 'fig_4_9_c';

V = [0 -1; 1 0; 0 1; -1 0];
Q = polytope(V);
P = unitbox(2)*2;
PmQ = P - Q;
PmQpQ = PmQ + Q;

% plot the result
plot(PmQpQ, 'c', PmQ, 'y');
axis([-2.1 2.1 -2.1 2.1]);
% text in polytopes
text(-1, 1.5, 'PmQpQ');
text(-0.5, 0, 'PmQ');


% custom axis labels & font size
h = xlabel('x_1');
set(h, 'FontSize', label_font_size);
h = ylabel('x_2');
set(h, 'FontSize', label_font_size);
h = zlabel('x_3');
set(h, 'FontSize', label_font_size);

% font size of tick labels
set(gca, 'FontSize', tick_font_size);

% generate FIG file
saveas(gcf, [figure_name '_matlab'], 'fig');

% generate color EPS
print('-depsc2', '-r300', [figure_name '_color.eps']);

% generate B&W EPS
print('-deps', '-r300', [figure_name '_bw.eps']);

% print using laprint
close all
% plot the result
plot(PmQpQ, 'c', PmQ, 'y');
axis([-2.1 2.1 -2.1 2.1]);
% text in polytopes
text(-1, 1.5, '(\mathcal{P} \ominus \mathcal{Q}) \oplus \mathcal{Q}');
text(-0.5, 0, '\mathcal{P} \ominus \mathcal{Q}');
% axis
h = xlabel('x_1');
set(h, 'FontSize', label_font_size);
h = ylabel('x_2');
set(h, 'FontSize', label_font_size);
set(gca, 'FontSize', tick_font_size);
laprint(gcf, [figure_name '_tex']);

fprintf('Figure "%s" generated...\n', figure_name);
disp('Use PSFRAG substitution: "PmQ" -> "\mathcal{P} \ominus \mathcal{Q}"');
disp('Use PSFRAG substitution: "PmQpQ" -> "(\mathcal{P} \ominus \mathcal{Q}) \oplus \mathcal{Q}"');

close all

function fnDisplayError( Ref_X, DistErr_X, DistErr_Y )
DistErr = sqrt(DistErr_X.*DistErr_X + DistErr_Y.*DistErr_Y);

figure();
subplot(3,1,1);
plot(Ref_X, DistErr_X, '.'); hold on;
plot([0, max(Ref_X)], [mean(abs(DistErr_X)), mean(abs(DistErr_X))], 'r');
ylim([-5 5]);
xlabel('X(m)'); ylabel('Error(m)');
grid on;
title(['X error(mean): ', num2str(mean(abs(DistErr_X))), ' (m)']);

subplot(3,1,2);
plot(Ref_X, DistErr_Y, '.'); hold on;
plot([0, max(Ref_X)], [mean(abs(DistErr_Y)), mean(abs(DistErr_Y))], 'r');
ylim([-5 5]);
xlabel('X(m)'); ylabel('Error(m)');
grid on;
title(['Y error(mean): ', num2str(mean(abs(DistErr_Y))), ' (m)']);

subplot(3,1,3);
plot(Ref_X, DistErr, '.'); hold on;
plot([0, max(Ref_X)], [mean(abs(DistErr)), mean(abs(DistErr))], 'r');
ylim([-5 5]);
xlabel('X(m)'); ylabel('Error(m)');
grid on;
title(['Dist error(mean): ', num2str(mean(abs(DistErr))), ' (m)']);
end


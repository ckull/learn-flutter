import { ForbiddenException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { AuthSigninDto, AuthSignupDto } from './dto';
import * as argon2 from 'argon2';
import { Tokens } from './types';
import { JwtService } from '@nestjs/jwt';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
import { ConfigService } from '@nestjs/config';
import { User } from './types/user.type';
@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private config: ConfigService,
  ) {}

  // `Signup` Route
  async signup(dto: AuthSignupDto): Promise<any> {
    const password = await this.generateArgonHash(dto.password);

    try {
      const newUser = await this.prisma.user.create({
        data: {
          username: dto.username,
          password,
        },
      });

      const tokens: Tokens = await this.generateTokens(
        newUser.id,
        newUser.username,
      );

      await this.updateRefreshTokenHash(newUser.id, tokens.refresh_token);

      const result: User = {
        id: newUser.id,
        username: newUser.username,
        created_at: newUser.created_at,
        updated_at: newUser.updated_at,
        tokens: { ...tokens },
      };
      return result;
    } catch (error) {
      if (error instanceof PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException('Duplicate Username');
        }
      }
      throw error;
    }
  }

  // `SignIn` Route
  async signin(dto: AuthSigninDto): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { username: dto.username },
    });

    if (!user) throw new ForbiddenException('Access Denied');

    const passwordMatches = await argon2.verify(user.password, dto.password);
    if (!passwordMatches) throw new ForbiddenException('Access Denied');

    const tokens: Tokens = await this.generateTokens(user.id, user.username);
    await this.updateRefreshTokenHash(user.id, tokens.refresh_token);
    const result: User = {
      id: user.id,
      username: user.username,
      created_at: user.created_at,
      updated_at: user.updated_at,
      tokens: { ...tokens },
    };

    return result;
  }

  // `Logout` Route
  async logout(userId: number) {
    await this.prisma.user.updateMany({
      where: {
        id: userId,
        hashedRT: {
          not: null,
        },
      },
      data: {
        hashedRT: null,
      },
    });
  }

  // `RefreshToken` Route
  async refreshTokens(userId: number, refreshToken: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    console.log('userId: ', userId);

    console.log('user: ', user);

    if (!user || !user.hashedRT) throw new ForbiddenException('Access Denied');

    const refreshTokenMatches = await argon2.verify(
      user.hashedRT,
      refreshToken,
    );

    if (!refreshTokenMatches) throw new ForbiddenException('Access Denied');

    const tokens: Tokens = await this.generateTokens(user.id, user.username);
    await this.updateRefreshTokenHash(user.id, tokens.refresh_token);
    return tokens;
  }

  async fetchUser(userId: number) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user) throw new ForbiddenException('Access Denied');

    return user;
  }

  /* --- Utility Functions --- */

  async generateArgonHash(data: string): Promise<string> {
    return await argon2.hash(data);
  }

  async updateRefreshTokenHash(
    userId: number,
    refreshToken: string,
  ): Promise<void> {
    const hash = await this.generateArgonHash(refreshToken);
    await this.prisma.user.update({
      where: { id: userId },
      data: { hashedRT: hash },
    });
  }

  async generateTokens(userId: number, username: string): Promise<Tokens> {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: userId,
          username,
        },
        {
          secret: this.config.get('JWT_ACCESS_TOKEN_SECRET_KEY'),
          expiresIn: this.config.get('ACCESS_TOKEN_LIFE_TIME') * 60,
        },
      ),
      this.jwtService.signAsync(
        {
          sub: userId,
          username,
        },
        {
          secret: this.config.get('JWT_REFRESH_TOKEN_SECRET_KEY'),
          expiresIn: this.config.get('REFRESH_TOKEN_LIFE_TIME') * 24 * 60 * 60,
        },
      ),
    ]);

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
    };
  }
}
